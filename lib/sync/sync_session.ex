defmodule KratosApi.Sync.Recess do
  import SweetXml

  @remote_scrape Application.get_env(:kratos_api, :remote_scraper)

  @senate_recess_source %{
    base_url: "https://www.senate.gov/legislative/",
    route: "_schedule.htm",
    dom_node: "table"
  }

  @house_recess_source %{
    url: "http://clerk.house.gov/floorsummary/floor-rss.ashx",
    mapping: [{:last_activity_on, [
      ~x"///item"l,
      date: ~x"./guid/text()"s,
    ]}]
  }

  @months %{
    "Jan": "01",
    "Feb": "02",
    "Mar": "03",
    "Apr": "04",
    "May": "05",
    "Jun": "06",
    "Jul": "07",
    "Aug": "08",
    "Sep": "09",
    "Oct": "10",
    "Nov": "11",
    "Dec": "12",
  }

  alias KratosApi.{
    Repo,
    CongressionalRecess
  }

  def sync() do
    sync(:senate)
  end
  def sync(:senate) do
    year = Date.utc_today() |> Map.get(:year)
    @remote_scrape.scrape(url(year), @senate_recess_source.dom_node)
    |> scrape_dates
    |> extract_dates
    |> Enum.map(&(convert_date(&1, year)))
    |> Enum.map(&(save(&1, year, "senate")))
  end

  defp url(year) do
     "#{@senate_recess_source.base_url}#{year}#{@senate_recess_source.route}"
  end

  def parse_date(%{date: date}) do
    Timex.parse!(date, "%Y%m%dT%H:%M:%S", :strftime)
  end

  defp scrape_dates(html) do
    html
    |> List.first
    |> elem(2)
    |> Enum.map(fn tr -> elem(tr, 2) |> List.first |> elem(2) end)
    |> List.flatten
  end

  defp extract_dates(date_string_array) do
    date_string_array
    |> List.delete("Date")
    |> Enum.map(&(String.split(&1, " - ")))
  end

  defp convert_date([single_date], year) do
    date = convert(single_date, year)
    [date, date]
  end
  defp convert_date(date_range, year) do
    Enum.map(date_range, &(convert(&1, year)))
  end

  defp convert(date, year) do
    [month, day] = String.split(date)
    Ecto.Date.cast!({year, Map.get(@months, String.to_atom(month)), day})
  end

  defp save([start_date, end_date], year, chamber) do
    %CongressionalRecess{
      start_date: start_date,
      end_date: end_date,
      year: year,
      chamber: chamber
    } |> Repo.insert!
  end

end

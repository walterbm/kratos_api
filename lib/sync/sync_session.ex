defmodule KratosApi.Sync.Recess do

  @remote_scrape Application.get_env(:kratos_api, :remote_scraper)

  @congress_recess_source %{
    base_url: "https://www.senate.gov/legislative/",
    route: "_schedule.htm",
    dom_node: "table"
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

  def sync(), do: sync(Date.utc_today() |> Map.get(:year))
  def sync(year) do
    @remote_scrape.scrape(page(year), @congress_recess_source.dom_node)
    |> scrape_dates
    |> extract_dates
    |> Enum.map(&(convert_date(&1, year)))
    |> Enum.map(&(save(&1, year)))
  end

  defp page(year) do
     "#{@congress_recess_source.base_url}#{year}#{@congress_recess_source.route}"
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

  defp save([start_date, end_date], year) do
    %CongressionalRecess{
      start_date: start_date,
      end_date: end_date,
      year: year,
    } |> Repo.insert!
  end

end

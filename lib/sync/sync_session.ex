defmodule KratosApi.Sync.Session do

  @remote_scrape Application.get_env(:kratos_api, :remote_scraper)

  @congress_session_source %{
    url: "https://www.senate.gov/legislative/2017_schedule.htm",
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

  def sync() do
    @remote_scrape.scrape(@congress_session_source.url, @congress_session_source.dom_node)
    |> List.first
    |> elem(2)
    |> Enum.map(fn tr -> elem(tr, 2) |> List.first |> elem(2) end)
    |> List.flatten
    |> List.delete("Date")
  end

end

defmodule KratosApi.RemoteService do

  @bio_base_url "https://en.wikipedia.org/w/api.php"

  # https://en.wikipedia.org/w/api.php?action=help&modules=query
  def fetch_bio(wikipedia_title) do
    HTTPotion.get(@bio_base_url, query: %{
      action: "query",
      prop: "extracts",
      titles: wikipedia_title,
      exintro: true,
      exsentences: "5",
      explaintext: true,
      redirects: true,
      format: "json",
      formatversion: 2
    })
    |> Map.get(:body)
    |> Poison.decode!
    |> Map.get("query", false)
    |> get_bio
  end

  defp get_bio(%{"pages" => pages}) do
    pages
    |> List.first
    |> extract_bio
  end
  defp get_bio(false), do: "No Bio Found"

  defp extract_bio(%{"extract" => bio, "ns" => _, "pageid" => _, "title" => _}), do: bio
  defp extract_bio(%{"missing" => true, "ns" => _, "title" => _}), do: "No Bio Found"

end

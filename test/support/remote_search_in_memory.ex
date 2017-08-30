defmodule KratosApi.Search.Remote.InMemory do

  def search(index, types \\ [], query \\ %{}) do
    {:ok,
     %HTTPoison.Response{body: %{"error" => %{"index" => "congress",
          "index_uuid" => "_na_", "reason" => "no such index",
          "resource.id" => "congress", "resource.type" => "index_or_alias",
          "root_cause" => [%{"index" => "congress", "index_uuid" => "_na_",
             "reason" => "no such index", "resource.id" => "congress",
             "resource.type" => "index_or_alias",
             "type" => "index_not_found_exception"}],
          "type" => "index_not_found_exception"}, "status" => 404},
      headers: [{"Access-Control-Allow-Origin", "*"},
       {"Content-Type", "application/json; charset=UTF-8"},
       {"Content-Length", "355"}, {"Connection", "keep-alive"}],
      request_url: "***REMOVED***/congress/bill/_search",
      status_code: 404}}
  end

  def mapping(index, type, mapping) do
    true
  end

  def save(index, type, document) do
    true
  end

end

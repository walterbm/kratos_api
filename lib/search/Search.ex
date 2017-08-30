defmodule KratosApi.Search do
  @remote_search KratosApi.Search.Remote

  def search(index, types, query) do
    @remote_search.search(index, types, query)
  end

  def simple_search(index, types, query) do
    query_payload = %{
      query: %{
         query_string: %{
            query: query
         }
      }
    }
    @remote_search.search(index, types, query_payload)
    |> parse_response
  end
  
  def mapping(index, type, mapping) do
    @remote_search.search(index, type, mapping)
  end

  def save(index, type, document) do
    @remote_search.search(index, type, document)
  end

  defp parse_response(http_response) do
    with {:ok, response} <- http_response,
         {:ok, body}     <- read_body(response.body)
    do
      body
    else
      err -> err
    end
  end

  defp read_body(%{"error" => error}), do: {:error, error}
  defp read_body(body), do: body

end

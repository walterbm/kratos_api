defmodule Kratos.Search do

  @config Application.get_env(:kratos_api, :elastic_search, %{})

  def search(index \\ "movies", types \\ []) do
    Elastix.Search.search(@config.host, index, types, %{})
  end

  def save(index \\ "movies", type \\ "movie", document) do
    if document.id do
      Elastix.Document.index_new(@config.host, index, type, document)
    else
      Elastix.Document.index(@config.host, index, type, document.id, document)
    end
  end

  # def test do
  #   %{
  #     "director" => "Burton, Tim",
  #     "genre" => ["Action"],
  #     "year" => 1989,
  #     "actor" => ["Jack Nicholson","Michael Keaton","Kim Basinger"],
  #     "title" => "Batman"
  #   }
  # end

end

defmodule Kratos.Search.Auth do

  @config Application.get_env(:kratos_api, :elastic_search, %{})

  def add_aws_signature(request) do
    {:ok, headers} = generate_aws_signature(request)
    headers
  end

  defp config do
    Application.get_all_env(:ex_aws)
      |> Map.new
      |> Map.merge(@config)
  end

  defp generate_aws_signature(request) do
    url = @config.scheme <> request.url
    hashed_payload = ExAws.Auth.Utils.hash_sha256(request.body)
    headers = Map.new
      |> Map.put("x-amz-content-sha256", hashed_payload)
      |> Map.put("content-length", byte_size(request.body))
      |> Map.to_list
      |> Kernel.++(request.headers)

    ExAws.Auth.headers(request.method, url, :es, config(), headers, request.body)
  end

end

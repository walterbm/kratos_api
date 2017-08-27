defmodule KratosApi.Search do
  @remote_search Application.get_env(:kratos_api, :remote_search)

  def search(index, types, query) do
    @remote_search.search(index, types, query)
  end

  def mapping(index, type, mapping) do
    @remote_search.search(index, type, mapping)
  end

  def save(index, type, document) do
    @remote_search.search(index, type, document)
  end

end

defmodule Kratos.Search.Remote do

  @config Application.get_env(:kratos_api, :elastic_search, %{})

  def search(index, types \\ [], query \\ %{}) do
    Elastix.Search.search(@config.host, index, types, query)
  end

  def mapping(index, type, mapping) do
    Elastix.Mapping.put(@config.host, index, type, mapping)
  end

  def save(index, type, document) do
    if document.id do
      Elastix.Document.index_new(@config.host, index, type, document)
    else
      Elastix.Document.index(@config.host, index, type, document.id, document)
    end
  end

end

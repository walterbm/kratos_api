defmodule KratosApi.RemoteStorage do

  @bucket "kratos-congress-legislators"

  def fetch_file(file) do
    reponse = ExAws.S3.get_object(@bucket, file) |> ExAws.request!
    { _key, md5hash } = List.keyfind(reponse.headers, "ETag", 0)
    { reponse.body, md5hash }
  end

  def parse_file(file_as_string) do
    [ document | _ ]  = :yamerl_constr.string(file_as_string)
    document
  end

end

defmodule KratosApi.TokenGen.InMemory do
  @reset_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAbWN0ZXN0LmNvbSIsImV4cCI6MTQ4NTQ5NDA1NX0.UNHlg-iTt_cNFtYOqEUIvHguMTQ51wQ4SNAozPsJZfo"

  def token(_), do: nil
  def with_exp(_), do: nil
  def sign(_), do: nil
  def get_compact(_), do: @reset_token
  def with_validation(_, _, _), do: nil
  def with_signer(_, _), do: nil
  def hs256(_), do: nil
  def verify!(_), do: {:ok, %{"email" => "test@mctest.com"}}

  def get_reset_token(), do: @reset_token
end

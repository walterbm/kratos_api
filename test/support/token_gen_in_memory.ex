defmodule KratosApi.TokenGen.InMemory do
  @token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAbWN0ZXN0LmNvbSIsImV4cCI6MTQ4NTQ5NDA1NX0.UNHlg-iTt_cNFtYOqEUIvHguMTQ51wQ4SNAozPsJZfo"

  def token(t \\ @token), do: t
  def with_exp(t), do: t
  def sign(t), do: t
  def get_compact(_), do: @token
  def with_validation(t, _, _), do: t
  def with_signer(t, _), do: t
  def hs256(t), do: t
  def verify!(@token), do: {:ok, %{"email" => KratosApi.Teststubs.user.email}}
  def verify!(_), do: {:error, "Invalid signature"}

  def get_test_token(), do: @token
end

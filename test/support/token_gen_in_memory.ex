defmodule KratosApi.TokenGen.InMemory do
  @token "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODc2MTM0NzAsImlhdCI6MTU4NzUyNzA3MCwiaXNzIjoiS3JhdG9zQXBpVGVzdCIsImp0aSI6IjZkYzE3M2NiLTc1NTItNDM5Zi05OGI1LTJjYzBiY2Q2ZjgwZCIsInBlbSI6e30sInN1YiI6IlVzZXI6MzI3NiIsInR5cCI6InRva2VuIn0.r4yBMJdGo9pzsRjF2PhfPIwkJzfw2d6Qwx2lK5wYsr5peoztGc5MAzAcWLK4_Lhc4ShdoE-a1Dbu_jhm-4WfQw"

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

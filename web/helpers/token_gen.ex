defmodule KratosApi.TokenGen do

  def token(arg), do: Joken.token(arg)
  def with_exp(arg), do: Joken.with_exp(arg)
  def sign(arg), do: Joken.sign(arg)
  def get_compact(arg), do: Joken.get_compact(arg)
  def with_validation(arg1, arg2, arg3), do: Joken.with_validation(arg1, arg2, arg3)
  def with_signer(arg1, arg2), do: Joken.with_signer(arg1, arg2)
  def hs256(arg), do: Joken.hs256(arg)
  def verify!(arg), do: Joken.verify!(arg)

end

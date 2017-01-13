defmodule KratosApi.Teststubs do
  @user %{email: "test@mctest.com", apn_token: "<mock>", password: "password"}
  def user, do: @user
end

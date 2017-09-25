defmodule KratosApi.Notifications.Message do
  @enforce_keys [:body]
  defstruct [:body, :title]
end

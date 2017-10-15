defmodule KratosApi.CMSView do
  use KratosApi.Web, :view

  @states Application.get_env(:kratos_api, :us_states_and_territories)
  def states, do: @states

end

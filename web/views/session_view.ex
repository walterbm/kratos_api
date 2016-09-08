defmodule KratosApi.SessionView do
  use KratosApi.Web, :view

  def render("show.json", %{jwt: jwt, user: user}) do
    %{ token: jwt, user: user }
  end

  def render("error.json", _) do
    %{error: "Invalid email or password"}
  end
end

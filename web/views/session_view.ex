defmodule KratosApi.SessionView do
  use KratosApi.Web, :view

  def render("show.json", %{jwt: jwt, user: user}) do
    %{ token: jwt, user: user }
  end

  def render("error.json", _) do
    %{error: "Invalid phone number or password"}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end

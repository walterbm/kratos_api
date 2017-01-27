defmodule KratosApi.SessionView do
  use KratosApi.Web, :view

  def render("show.json", %{jwt: jwt, user: user}) do
    %{ token: jwt, user: user }
  end

  def render("error.json", _) do
    %{
      errors: [
        %{ error: "Invalid email or password" }
      ]
    }
  end

  def render("delete.json", _) do
    %{ ok: true }
  end

  def render("forbidden.json", %{ error: error }) do
    %{
      errors: [
        %{ error: error }
      ]
    }
  end
end

defmodule KratosApi.SessionView do
  use KratosApi.Web, :view

  alias KratosApi.ErrorView

  def render("show.json", %{jwt: jwt}) do
    %{ token: jwt }
  end

  def render("error.json", %{message: message}) do
    %{ error: message } |> KratosApi.ErrorView.wrap
  end

  def render("delete.json", _) do
    %{ ok: true }
  end

  def render("forbidden.json", %{ error: error }) do
    %{ error: error } |> KratosApi.ErrorView.wrap
  end

  def render("unconfirmed.json", _assigns) do
    %{ unconfirmed: "Account has not been confirmed" } |> ErrorView.wrap
  end
end

defmodule KratosApi.JobController do
  use KratosApi.Web, :controller

  plug KratosApi.BasicAuth

  def run(conn, %{"type" => type}) do
    type
    |> String.to_atom
    |> KratosApi.Sync.sync

    json conn, %{ok: true}
  end

  def run(conn, _) do
    conn
    |> put_status(400)
    |> json(%{error: "No matching job"})
  end

end

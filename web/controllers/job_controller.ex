defmodule KratosApi.JobController do
  use KratosApi.Web, :controller

  plug KratosApi.BasicAuth

  def run(conn, %{"type" => type}) do
    response = case Task.start(KratosApi.Sync, :sync, [String.to_atom(type)]) do
      {:ok, _pid} -> %{ok: "job started"}
      _ -> %{error: "job failed to start"}
    end

    json conn, response
  end

  def run(conn, _) do
    conn
    |> put_status(400)
    |> json(%{error: "No matching job"})
  end

end

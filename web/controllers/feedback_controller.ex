defmodule KratosApi.FeedbackController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  alias KratosApi.ErrorView

  def index(conn, _params) do
    result = case ExAws.Dynamo.scan("kratos-feedback-questions") |> ExAws.request do
      {:ok, data} ->
        %{ "questions" => Enum.map(data["Items"], &(&1["question"]["S"])) }
      {:error, {_exception, message}} ->
        %{ error: message } |> ErrorView.wrap
    end
    json conn, result
  end

  def create(conn, %{"answers" => answers, "user-id" => user_id}) do
    now = DateTime.utc_now() |> DateTime.to_string
    feedback = Map.merge(%{"date-userid" => "#{now} --- #{user_id}", "user-id" => user_id}, answers)
    ExAws.Dynamo.put_item("kratos-feedback-answers", feedback) |> ExAws.request!

    json conn, %{ok: true}
  end

end

defmodule KratosApi.UserAnalytics do

  def mark_online(user) do
    changeset = user
      |> KratosApi.User.last_online_changeset(%{last_online_at: Ecto.DateTime.utc()})

    Task.start(KratosApi.Repo, :update, [changeset])
  end

  def confirm_email(user \\ %KratosApi.User{}) do
    if user do
      user
        |> KratosApi.User.confirm_email_changeset(%{confirmed_email_at: Ecto.DateTime.utc()})
        |> KratosApi.Repo.update
    else
      {:error, "User not found"}
    end
  end
end

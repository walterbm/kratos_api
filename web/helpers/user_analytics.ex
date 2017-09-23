defmodule KratosApi.UserAnalytics do

  alias KratosApi.{
    Repo,
    User,
  }

  def mark_online(user) do
    changeset = user
      |> User.last_online_changeset(%{last_online_at: Ecto.DateTime.utc()})

    Task.start(Repo, :update, [changeset])
  end

  def confirm_email(user \\ %User{}) do
    if user do
      user
        |> User.confirm_email_changeset(%{confirmed_email_at: Ecto.DateTime.utc()})
        |> Repo.update
    else
      {:error, "User not found"}
    end
  end
end

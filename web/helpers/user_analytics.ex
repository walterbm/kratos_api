defmodule KratosApi.UserAnalytics do

  def mark_online(user) do
    changeset = user
      |> KratosApi.User.last_online_changeset(%{last_online_at: Ecto.DateTime.utc()})

    Task.start(KratosApi.Repo, :update, [changeset])
  end
end

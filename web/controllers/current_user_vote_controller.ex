defmodule KratosApi.CurrentUserVoteController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  plug :scrub_params, "vote" when action in [:create, :update]

  alias KratosApi.{
    Repo,
    UserVote,
    Tally,
    VoteView
  }

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    query = from v in UserVote,
        join: t in Tally,
        where: v.tally_id == t.id,
        where: v.user_id == ^user.id,
        preload: [:tally]

    {user_votes, kerosene} = query |> Repo.paginate(params)

    render(conn, VoteView, "user_votes.json", user_votes: user_votes, kerosene: kerosene)
  end

  # Careful! Any user can view/update/delete the votes of another!

  def show(conn, %{"id" => id}) do
    vote = UserVote |> Repo.get!(id) |> Repo.preload([:tally])
    render(conn, VoteView, "vote_record.json", vote: vote)
  end

  def create(conn, %{"vote" => %{"tally_id" => tally_id, "value" => value} }) do
    user = Guardian.Plug.current_resource(conn)
    vote = UserVote.get_or_create(user.id, tally_id, value)

    render(conn, VoteView, "vote_record.json", vote: vote)
  end

  def update(conn, %{"id" => id, "vote" => %{"value" => value} }) do
    updated_vote = Ecto.Changeset.change Repo.get!(UserVote, id), value: value
    vote = Repo.update!(updated_vote) |> Repo.preload([:tally])
    render(conn, VoteView, "vote_record.json", vote: vote)
  end

  def delete(conn, %{"id" => id}) do
    vote = Repo.get!(UserVote, id)
    Repo.delete! vote

    json conn, %{ok: true}
  end

end

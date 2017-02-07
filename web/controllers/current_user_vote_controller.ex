defmodule KratosApi.CurrentUserVoteController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  plug :scrub_params, "vote" when action in [:create, :update]

  alias KratosApi.{
    Repo,
    UserVote,
    VoteView
  }

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    query = from v in UserVote,
        where: v.user_id == ^user.id,
        preload: [:tally]

    {user_votes, kerosene} = query |> Repo.paginate(params)

    render(conn, VoteView, "user_votes.json", user_votes: user_votes, kerosene: kerosene)
  end

  def show(conn, %{"id" => tally_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from v in UserVote,
        where: v.tally_id == ^tally_id,
        where: v.user_id == ^user.id

    case Repo.one(query) do
      nil ->  json conn, %{error: "User has not voted on this question yet!"}
      vote -> render(conn, VoteView, "user_vote_record.json", vote: vote)
    end
  end

  def create(conn, %{"vote" => %{"tally_id" => tally_id, "value" => value} }) do
    user = Guardian.Plug.current_resource(conn)
    vote = UserVote.get_or_create(user.id, tally_id, value)

    render(conn, VoteView, "vote_record.json", vote: vote)
  end

  def update(conn, %{"id" => tally_id, "vote" => %{"value" => value} }) do
    user = Guardian.Plug.current_resource(conn)
    query = from v in UserVote,
        where: v.tally_id == ^tally_id,
        where: v.user_id == ^user.id

    updated_vote =
      Ecto.Changeset.change(Repo.one!(query), value: value)
      |> Repo.update!
      |> Repo.preload([:tally])

    render(conn, VoteView, "vote_record.json", vote: updated_vote)
  end

  def delete(conn, %{"id" => tally_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from v in UserVote,
        where: v.tally_id == ^tally_id,
        where: v.user_id == ^user.id

    Repo.one!(query) |> Repo.delete!

    json conn, %{ok: true}
  end

end

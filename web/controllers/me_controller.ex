defmodule KratosApi.MeController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController
  plug :scrub_params, "user" when action in [:update]
  plug :scrub_params, "user_action" when action in [:create_action]
  plug :scrub_params, "track" when action in [:track_bill]
  plug :scrub_params, "follow" when action in [:track_subject]
  plug :scrub_params, "vote" when action in [:create_vote, :update_vote]

  alias KratosApi.{
    Repo,
    Bill,
    User,
    Subject,
    UserBill,
    UserVote,
    UserView,
    BillView,
    VoteView,
    ErrorView,
    UserAction,
    UserSubject,
    SubjectView,
    FindDistrict,
    RegistrationView
  }

  # User

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> render(UserView, "show.json", user: user)
  end

  def update(conn, %{"user" => user_params }) do
    updated_user = Map.merge(user_params, FindDistrict.by_address(user_params))
    changeset = User.update_changeset(Guardian.Plug.current_resource(conn), updated_user)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(UserView, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RegistrationView, "error.json", changeset: changeset)
    end
  end

  # Actions

  def create_action(conn, %{"user_action" => user_action }) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserAction.changeset(%UserAction{}, Map.merge(user_action, %{"user_id" => user.id}))
    Repo.insert!(changeset)

    json conn, %{ok: true}
  end

  # Bills

  def bills(conn, %{"onlyids" => "true"}) do
    user = Guardian.Plug.current_resource(conn)
    bill_ids = Bill.following_ids(user.id)

    json conn, %{data: bill_ids}
  end
  def bills(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    query = Bill.query_mine(user.id, params)

    {user_bills, kerosene} = query |> Repo.paginate(params)

    render(conn, BillView, "bills.json", bills: user_bills, kerosene: kerosene)
  end

  def bill(conn, %{"id" => bill_id}) do
    query = from b in Bill,
      where: b.id == ^bill_id,
      preload: [:top_subject]

    case Repo.one(query) do
      nil  -> render(conn, ErrorView, "not_following_bill.json")
      bill -> render(conn, BillView, "bill_light.json", bill: bill)
    end
  end

  def track_bill(conn, %{"track" => %{"bill_id" => bill_id} }) do
    user = Guardian.Plug.current_resource(conn)
    UserBill.get_or_create(user.id, bill_id)
    bill_ids = Bill.following_ids(user.id)

    json conn, %{data: bill_ids}
  end
  def track_bill(conn, _) do
    render conn, ErrorView, "500.json"
  end

  def untrack_bill(conn, %{"id" => bill_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from b in UserBill,
        where: b.bill_id == ^bill_id,
        where: b.user_id == ^user.id

    Repo.one!(query) |> Repo.delete!

    json conn, %{ok: true}
  end

  # Subjects

  def subjects(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    query = from s in Subject,
      join: following in UserSubject, on: s.id == following.subject_id,
      where: following.user_id == ^user.id

    render(conn, SubjectView, "subjects.json", subjects: Repo.all(query))
  end

  def track_subject(conn, %{"follow" => %{"subject_id" => subject_id} }) do
    user = Guardian.Plug.current_resource(conn)
    following = UserSubject.get_or_create(user.id, subject_id) |> Repo.preload(:subject)

    json conn, %{following: following.subject.name}
  end
  def track_subject(conn, _) do
    render conn, ErrorView, "400.json"
  end

  def untrack_subject(conn, %{"id" => subject_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from s in UserSubject,
        where: s.subject_id == ^subject_id,
        where: s.user_id == ^user.id

    Repo.one!(query) |> Repo.delete!

    json conn, %{ok: true}
  end

  # Votes

  def votes(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    query = from v in UserVote,
        where: v.user_id == ^user.id,
        preload: [tally: :bill]

    {user_votes, kerosene} = query |> Repo.paginate(params)

    render(conn, VoteView, "user_votes.json", user_votes: user_votes, kerosene: kerosene)
  end

  def vote(conn, %{"id" => tally_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from v in UserVote,
        where: v.tally_id == ^tally_id,
        where: v.user_id == ^user.id,
        preload: [tally: :bill]

    case Repo.one(query) do
      nil ->  render(conn, ErrorView, "not_voted.json")
      vote -> render(conn, VoteView, "user_vote_record.json", vote: vote)
    end
  end

  def create_vote(conn, %{"vote" => %{"tally_id" => tally_id, "value" => value} }) do
    user = Guardian.Plug.current_resource(conn)
    vote =
      UserVote.get_or_create(user.id, tally_id, value)
      |> Repo.preload(tally: :bill)

    render(conn, VoteView, "vote_record.json", vote: vote)
  end

  def update_vote(conn, %{"id" => tally_id, "vote" => %{"value" => value} }) do
    user = Guardian.Plug.current_resource(conn)
    query = from v in UserVote,
        where: v.tally_id == ^tally_id,
        where: v.user_id == ^user.id,
        preload: [tally: :bill]

    updated_vote =
      Ecto.Changeset.change(Repo.one!(query), value: value)
      |> Repo.update!
      |> Repo.preload([tally: :bill])

    render(conn, VoteView, "vote_record.json", vote: updated_vote)
  end

  def delete_vote(conn, %{"id" => tally_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from v in UserVote,
        where: v.tally_id == ^tally_id,
        where: v.user_id == ^user.id

    Repo.one!(query) |> Repo.delete!

    json conn, %{ok: true}
  end


end

defmodule KratosApi.CurrentUserBillController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  plug :scrub_params, "track" when action in [:create]

  alias KratosApi.{
    Repo,
    Bill,
    UserBill,
    BillView,
    ErrorView,
  }

  def index(conn, %{"onlyids" => "true"}) do
    user = Guardian.Plug.current_resource(conn)
    bill_ids = Bill.following_ids(user.id)

    json conn, %{data: bill_ids}
  end
  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    query = Bill.query_mine(user.id, params)

    {user_bills, kerosene} = query |> Repo.paginate(params)

    render(conn, BillView, "bills.json", bills: user_bills, kerosene: kerosene)
  end

  def show(conn, %{"id" => bill_id}) do
    query = from b in Bill,
      where: b.id == ^bill_id,
      preload: [:top_subject]

    case Repo.one(query) do
      nil  -> render(conn, ErrorView, "not_following_bill.json")
      bill -> render(conn, BillView, "bill_light.json", bill: bill)
    end
  end

  def create(conn, %{"track" => %{"bill_id" => bill_id} }) do
    user = Guardian.Plug.current_resource(conn)
    UserBill.get_or_create(user.id, bill_id)
    bill_ids = Bill.following_ids(user.id)

    json conn, %{data: bill_ids}
  end
  def create(conn, _) do
    render conn, ErrorView, "500.json"
  end

  def delete(conn, %{"id" => bill_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from b in UserBill,
        where: b.bill_id == ^bill_id,
        where: b.user_id == ^user.id

    Repo.one!(query) |> Repo.delete!

    json conn, %{ok: true}
  end

end

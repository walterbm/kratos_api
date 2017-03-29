defmodule KratosApi.CurrentUserBillController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  plug :scrub_params, "track" when action in [:create]

  alias KratosApi.{
    Repo,
    Bill,
    UserBill,
    BillView
  }

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    query = from b in Bill,
      join: following in UserBill, on: b.id == following.bill_id,
      where: following.user_id == ^user.id

    {user_bills, kerosene} = query |> Repo.paginate(params)

    render(conn, BillView, "bills.json", bills: user_bills, kerosene: kerosene)
  end

  def show(conn, %{"id" => bill_id}) do
    query = from b in Bill,
        where: b.id == ^bill_id

    case Repo.one(query) do
      nil ->  json conn, %{error: "User is not following this Bill"}
      bill -> render(conn, BillView, "bill_light.json", bill: bill)
    end
  end

  def create(conn, %{"track" => %{"bill_id" => bill_id} }) do
    user = Guardian.Plug.current_resource(conn)
    UserBill.get_or_create(user.id, bill_id)

    json conn, %{following: bill_id}
  end
  def create(conn, _) do
    json conn, %{error: "Malformed JSON body"}
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

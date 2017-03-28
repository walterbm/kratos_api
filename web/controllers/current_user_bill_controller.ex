defmodule KratosApi.CurrentUserBillController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  plug :scrub_params, "follow" when action in [:create]

  alias KratosApi.{
    Repo,
    Bill,
    UserBill,
    BillView
  }

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    query = from b in UserBill,
        where: b.user_id == ^user.id

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

  def create(conn, %{"follow" => %{"bill_id" => bill_id} }) do
    user = Guardian.Plug.current_resource(conn)
    bill = UserBill.get_or_create(user.id, bill_id)

    render(conn, BillView, "bill_light.json", bill: bill)
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
defmodule KratosApi.UserView do
  use KratosApi.Web, :view

  def render("show.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      city: user.city,
      zip: user.zip,
      state: user.state,
      district: user.district,
      party: user.party,
      birthday: user.birthday,
      has_push_token: !!user.push_token
    }
  end

  def render("error.json", _) do
  end
end

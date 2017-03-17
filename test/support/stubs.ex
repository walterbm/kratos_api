defmodule KratosApi.Teststubs do
  @user %{email: "test@mctest.com", apn_token: "<mock>", password: "password"}
  def user, do: @user

  @kawhi %{
    user: %{
      first_name: "Kawhi",
      last_name: "Leonard",
      email: "kawhi@goat.com",
      password: "1stTeamAllDefense",
      address: "1 AT&T Center Parkway",
      city: "San Antonio",
      state: "TX",
      zip: 78219,
      apn_token: "<ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b5969>"
    }
  }
  def kawhi, do: @kawhi
  
end

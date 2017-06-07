defmodule KratosApi.Teststubs do
  @user %{
    first_name: "Tim",
    last_name: "Duncan",
    email: "timmy@goat.com",
    password: "FiveRings",
    address: "1 AT&T Center Parkway",
    city: "San Antonio",
    state: "TX",
    zip: 78219,
    apn_token: "<mock>",
    birthday: ~D[1976-04-25],
    district: "20",
    party: "Democrat",
    phone: "5555555555"
  }
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
      district: "20",
      birthday: ~D[1991-06-29],
      party: "Independent",
      phone: "4444444444",
      apn_token: "<ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b5969>"
    }
  }
  def kawhi, do: @kawhi

end

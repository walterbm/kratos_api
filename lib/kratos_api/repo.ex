defmodule KratosApi.Repo do
  use Ecto.Repo, otp_app: :kratos_api
  use Kerosene, per_page: 20
end

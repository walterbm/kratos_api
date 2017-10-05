defmodule KratosApi.Analytics do
  @moduledoc """
  The Analytics context.
  """

  import Ecto.Query, warn: false
  alias KratosApi.Repo

  alias KratosApi.Analytics.TrackResource

  @doc """
  Track a resource.
  """
  def track_resource(%{"resource_type" => resource_type, "resource_id" => resource_id, "user_id" => user_id}) do
    %TrackResource{}
    |> TrackResource.changeset(%{resource_type: resource_type, resource_id: resource_id, user_id: user_id})
    |> Repo.insert()
  end

end

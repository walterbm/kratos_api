defmodule KratosApi.MissingDataTest do
  use KratosApi.ModelCase

  alias KratosApi.MissingData

  @valid_attrs %{collected: true, govtrack_id: 42, type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MissingData.changeset(%MissingData{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MissingData.changeset(%MissingData{}, @invalid_attrs)
    refute changeset.valid?
  end
end

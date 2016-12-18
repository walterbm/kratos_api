defmodule KratosApi.NominationTest do
  use KratosApi.ModelCase

  alias KratosApi.Nomination

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Nomination.changeset(%Nomination{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Nomination.changeset(%Nomination{}, @invalid_attrs)
    refute changeset.valid?
  end
end

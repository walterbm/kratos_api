defmodule KratosApi.CongressNumberTest do
  use KratosApi.ModelCase

  alias KratosApi.CongressNumber

  @valid_attrs %{number: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CongressNumber.changeset(%CongressNumber{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CongressNumber.changeset(%CongressNumber{}, @invalid_attrs)
    refute changeset.valid?
  end
end

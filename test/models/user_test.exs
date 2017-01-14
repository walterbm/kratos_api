defmodule KratosApi.UserTest do
  use KratosApi.ModelCase

  alias KratosApi.User

  @valid_attrs KratosApi.Teststubs.user
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end

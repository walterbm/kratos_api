defmodule KratosApi.TermTest do
  use KratosApi.ModelCase

  alias KratosApi.Term

  @valid_attrs %{govtrack_id: 42, name: "some content", term_type: "some content", term_type_label: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Term.changeset(%Term{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Term.changeset(%Term{}, @invalid_attrs)
    refute changeset.valid?
  end
end

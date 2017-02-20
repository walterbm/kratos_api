defmodule KratosApi.FileHashTest do
  use KratosApi.ModelCase

  alias KratosApi.FileHash

  @valid_attrs %{file: "some content", hash: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FileHash.changeset(%FileHash{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FileHash.changeset(%FileHash{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "exists?" do
    assert FileHash.exists?("new_hash", "test_file.ex") == {:ok, :new}
    assert FileHash.exists?("new_hash", "test_file.ex") == {:ok, :exists}
  end
end

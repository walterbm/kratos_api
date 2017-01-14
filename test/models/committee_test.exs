defmodule KratosApi.CommitteeTest do
  use KratosApi.ModelCase

  alias KratosApi.Committee

  @valid_attrs %{abbrev: "some content", code: "some content", committee: "some content", committee_type: "some content", committee_type_label: "some content", govtrack_id: 42, jurisdiction: "some content", jurisdiction_link: "some content", name: "some content", obsolete: true, url: "some content"}

  test "changeset with valid attributes" do
    changeset = Committee.changeset(%Committee{}, @valid_attrs)
    assert changeset.valid?
  end

end

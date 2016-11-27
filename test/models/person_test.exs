defmodule KratosApi.PersonTest do
  use KratosApi.ModelCase

  alias KratosApi.Person

  @valid_attrs %{
    bioguideid: "some content",
    govtrack_id: 11,
    birthday: %{day: 17, month: 4, year: 2010},
    cspanid: 42,
    firstname: "some content",
    gender: "some content",
    gender_label: "some content",
    govetrack_id: 42,
    lastname: "some content",
    link: "some content",
    middlename: "some content",
    name: "some content",
    namemod: "some content",
    nickname: "some content",
    osid: "some content",
    pvsid: "some content",
    sortname: "some content",
    twitterid: "some content",
    youtubeid: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Person.changeset(%Person{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Person.changeset(%Person{}, @invalid_attrs)
    refute changeset.valid?
  end
end

defmodule KratosApi.PersonTest do
  use KratosApi.ModelCase

  alias KratosApi.Person

  @valid_attrs %{
    bioguide: "some content",
    thomas: "some content",
    lis: "some content",
    opensecrets: "some content",
    votesmart: "some content",
    cspan: "some content",
    wikipedia: "some content",
    house_history: "some content",
    ballotpedia: "some content",
    maplight: "some content",
    icpsr: "some content",
    wikidata: "some content",
    google_entity_id: "some content",
    first_name: "some content",
    last_name: "some content",
    official_full_name: "some content",
    birthday: %{day: 17, month: 4, year: 2010},
    gender: "some content",
    religion: "some content",
    twitter: "some content",
    facebook: "some content",
    facebook_id: "some content",
    youtube_id: "some content",
    twitter_id: "some content",
    image_url: "some content",
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

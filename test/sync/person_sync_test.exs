defmodule KratosApi.PersonSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    Term,
    Person
  }

  test "syncing creates Person, Fec, and Terms models" do
    KratosApi.Sync.Person.sync

    assert Repo.all(Person) |> Enum.count == 4

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "B000944",
      preload: [:fec, :terms])

    assert person
    assert person.bioguide == "B000944"
    assert person.thomas == "00136"
    assert person.lis == "S307"
    assert person.opensecrets == "N00003535"
    assert person.votesmart == "27018"
    assert person.cspan == "5051"
    assert person.wikipedia == "Sherrod Brown"
    assert person.house_history == "9996"
    assert person.ballotpedia == "Sherrod Brown"
    assert person.maplight == "168"
    assert person.icpsr == "29389"
    assert person.wikidata == "Q381880"
    assert person.google_entity_id == "kg:/m/034s80"
    assert person.first_name == "Sherrod"
    assert person.last_name == "Brown"
    assert person.official_full_name == "Sherrod Brown"
    assert person.birthday == Ecto.Date.cast!("1952-11-09")
    assert person.gender == "M"
    assert person.religion == "Lutheran"
    assert person.image_url == "https://supersecretdatabase.com/225x275/B000944.jpg"
    assert person.is_current == true
    assert person.current_office == "Senate"
    assert person.current_state == "OH"
    assert person.current_district == nil
    assert person.current_party == "Democrat"

    assert person.fec
    assert Enum.map(person.fec, fn fec -> fec.number end) |> Enum.sort == ["H2OH13033", "S6OH00163"]

    assert person.terms
    assert person.terms |> Enum.count == 9
    last =
      person.terms
      |> Enum.sort(fn(term_one, term_two) -> term_one.end > term_two.end end)
      |> List.first
    assert last
    assert last.type == "Senate"
    assert last.start == Ecto.Date.cast!("2013-01-03")
    assert last.end == Ecto.Date.cast!("2019-01-03")
    assert last.state == "OH"
    assert last.party == "Democrat"
    assert last.class == "1"
    assert last.url == "https://www.brown.senate.gov"
    assert last.address == "713 Hart Senate Office Building Washington DC 20510"
    assert last.phone == "202-224-2315"
    assert last.fax == "202-228-6321"
    assert last.contact_form == "http://www.brown.senate.gov/contact"
    assert last.office == "713 Hart Senate Office Building"
    assert last.state_rank == "senior"
    assert last.rss_url == "http://www.brown.senate.gov/rss/feeds/?type=all&amp;"
  end

  test "syncing creates relationship from Terms to Person" do
    KratosApi.Sync.Person.sync

    end_date = Ecto.Date.cast!("2019-01-03")
    term = Repo.one!(
      from t in Term,
      where: t.address == "713 Hart Senate Office Building Washington DC 20510",
      where: t.end == ^end_date,
      preload: [:person])

    assert term
    assert term.person.official_full_name == "Sherrod Brown"
  end

  test "syncing a duplicate Person updates that person" do
    KratosApi.Sync.Person.sync

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "B000944",
      preload: [:fec, :terms])

    assert person
    assert person.terms |> Enum.count == 9
    assert person.fec |> Enum.count == 2

    Repo.delete_all(KratosApi.FileHash)
    KratosApi.Sync.Person.sync

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "B000944",
      preload: [:fec, :terms])

    assert person
    assert person.terms |> Enum.count == 9
    assert person.fec |> Enum.count == 2
  end

  test "syncing social media adds social media info to existing Person" do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Person.SocialMedia.sync

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "B000944")

    assert person
    assert person.twitter == "SenSherrodBrown"
    assert person.youtube == "SherrodBrownOhio"
    assert person.youtube_id == "UCgy8jfERh-t_ixkKKoCmglQ"
    assert person.twitter_id == "43910797"
  end

  test "syncing executive correctly labels current terms" do
    KratosApi.Sync.Person.sync(:executive)

    assert Repo.all(Person) |> Enum.count == 3

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "O000167",
      preload: [:terms])

    assert person
    assert person.thomas == "01763"
    assert person.lis == "S298"
    assert person.opensecrets == "N00009638"
    assert person.votesmart == "9490"
    assert person.first_name == "Barack"
    assert person.last_name == "Obama"
    assert person.birthday == Ecto.Date.cast!("1961-08-04")
    assert person.gender == "M"
    assert person.is_current == false
    assert person.terms |> Enum.count == 2

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "P000587",
      preload: [:terms])

    assert person
    assert person.last_name == "Pence"

    term = person.terms |> List.last
    assert term.type == "VP"
  end

  test "updating people who served in both the legislature and the executive" do
    KratosApi.Sync.Person.sync(:historical)
    KratosApi.Sync.Person.sync(:executive)

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "P000587",
      preload: [:terms])

    assert person
    assert person.last_name == "Pence"
    assert person.terms |> Enum.count == 7
  end

  test "updates the bios for all current members of the legislature and the executive" do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Person.Bio.sync

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "B000575")

    assert person
    assert person.is_current == true
    assert person.bio == "Roy Dean Blunt (born January 10, 1950) is an American politician who currently serves as the junior United States Senator from Missouri, having been in office since 2011. He is a member of the Republican Party.\nBlunt served as the United States Representative from Missouri's 7th congressional district from 1997 to 2011. The district contains most of Southwest Missouri, anchored in the city of Springfield, as well as the cities of Joplin, Carthage, and Neosho, and the popular tourist destination of Branson.\nBlunt served as House Majority Whip from 2003 to 2007, and was acting House Majority Leader from September 2005 to February 2006."

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "R000593")

    assert person
    assert person.is_current == true
    assert person.bio == "Dennis Alan Ross (born October 18, 1959) is an American politician who has been a member of the United States House of Representatives since 2011. A Republican from Florida, his district was numbered as Florida's 12th congressional district during his first two years in Congress; it has been the 15th district since 2013."

  end

end

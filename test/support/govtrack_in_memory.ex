defmodule KratosApi.Govtrack.InMemory do

  def roles(_) do
    %{
      "meta" => %{"limit" => 1, "offset" => 0, "total_count" => 543},
      "objects" => [
        %{
          "caucus" => nil,
          "congress_numbers" => [
            112,
            113,
            114
          ],
          "current" => true,
          "description" => "Junior Senator from Missouri",
          "district" => nil,
          "enddate" => "2017-01-03",
          "extra" => %{
            "address" => "260 Russell Senate Office Building Washington DC 20510",
            "contact_form" => "http://www.blunt.senate.gov/public/index.cfm/contact-form?p=contact-roy",
            "fax" => "202-224-8149",
            "office" => "260 Russell Senate Office Building",
            "rss_url" => "http://www.blunt.senate.gov/public/?a=rss.feed"
          },
          "id" => 268, "leadership_title" => nil, "party" => "Republican",
          "person" => %{
            "bioguideid" => "B000575",
            "birthday" => "1950-01-10",
            "cspanid" => 45465,
            "firstname" => "Roy",
            "gender" => "male",
            "gender_label" => "Male",
            "id" => 400034,
            "lastname" => "Blunt",
            "link" => "https://www.govtrack.us/congress/members/roy_blunt/400034",
            "middlename" => "",
            "name" => "Sen. Roy Blunt [R-MO]",
            "namemod" => "",
            "nickname" => "",
            "osid" => "N00005195",
            "pvsid" => "418",
            "sortname" => "Blunt, Roy (Sen.) [R-MO]",
            "twitterid" => "RoyBlunt",
            "youtubeid" => "SenatorBlunt"
          },
          "phone" => "202-224-5721",
          "role_type" => "senator",
          "role_type_label" => "Senator",
          "senator_class" => "class3",
          "senator_class_label" => "Class 3",
          "senator_rank" => "junior",
          "senator_rank_label" => "Junior",
          "startdate" => "2011-01-05",
          "state" => "MO",
          "title" => "Sen.",
          "title_long" => "Senator",
          "website" => "http://www.blunt.senate.gov"
        }
      ]
    }
  end

  def role(_) do
    %{"caucus" => nil, "congress_numbers" => [112,113,114], "current" => true,
      "description" => "Junior Senator from Missouri", "district" => nil,
      "enddate" => "2017-01-03",
      "extra" => %{"address" => "260 Russell Senate Office Building Washington DC 20510",
        "contact_form" => "http://www.blunt.senate.gov/public/index.cfm/contact-form?p=contact-roy",
        "fax" => "202-224-8149", "office" => "260 Russell Senate Office Building",
        "rss_url" => "http://www.blunt.senate.gov/public/?a=rss.feed"}, "id" => 268,
      "leadership_title" => nil, "party" => "Republican",
      "person" => %{"bioguideid" => "B000575", "birthday" => "1950-01-10",
        "cspanid" => 45465, "firstname" => "Roy", "gender" => "male",
        "gender_label" => "Male", "id" => 400034, "lastname" => "Blunt",
        "link" => "https://www.govtrack.us/congress/members/roy_blunt/400034",
        "middlename" => "", "name" => "Sen. Roy Blunt [R-MO]", "namemod" => "",
        "nickname" => "", "osid" => "N00005195", "pvsid" => "418",
        "sortname" => "Blunt, Roy (Sen.) [R-MO]", "twitterid" => "RoyBlunt",
        "youtubeid" => "SenatorBlunt"}, "phone" => "202-224-5721",
      "role_type" => "senator", "role_type_label" => "Senator",
      "senator_class" => "class3", "senator_class_label" => "Class 3",
      "senator_rank" => "junior", "senator_rank_label" => "Junior",
      "startdate" => "2011-01-05", "state" => "MO", "title" => "Sen.",
      "title_long" => "Senator", "website" => "http://www.blunt.senate.gov"}
  end

  def committees(_) do
    %{"meta" => %{"limit" => 1, "offset" => 0, "total_count" => 228},
      "objects" => [%{"abbrev" => "", "code" => "SSFR09",
         "committee" => %{"abbrev" => "ForRel", "code" => "SSFR",
           "committee" => nil, "committee_type" => "senate",
           "committee_type_label" => "Senate", "id" => 2627, "jurisdiction" => nil,
           "jurisdiction_link" => nil,
           "name" => "Senate Committee on Foreign Relations", "obsolete" => false,
           "url" => "http://foreign.senate.gov/"}, "committee_type" => nil,
         "id" => 2853, "jurisdiction" => nil, "jurisdiction_link" => nil,
         "name" => "Africa and Global Health Policy", "obsolete" => false,
         "url" => nil}]
      }
  end

  def committee(_) do
    %{"abbrev" => "ForRel", "code" => "SSFR", "committee" => nil,
      "committee_type" => "senate", "committee_type_label" => "Senate",
      "id" => 2627, "jurisdiction" => nil, "jurisdiction_link" => nil,
      "name" => "Senate Committee on Foreign Relations", "obsolete" => false,
      "url" => "http://foreign.senate.gov/"}
  end

end

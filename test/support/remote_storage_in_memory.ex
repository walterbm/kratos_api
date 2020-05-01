defmodule KratosApi.RemoteStorage.InMemory do

  # - id:\n
  #   bioguide: B000944\n
  #   thomas: '00136'\n
  #   lis: S307\n
  #   govtrack: 400050\n
  #   opensecrets: N00003535\n
  #   votesmart: 27018\n
  #   fec:\n
  #   - H2OH13033\n
  #   - S6OH00163\n
  #   cspan: 5051\n
  #   wikipedia: Sherrod Brown\n
  #   house_history: 9996\n
  #   ballotpedia: Sherrod Brown\n
  #   maplight: 168\n
  #   icpsr: 29389\n
  #   wikidata: Q381880\n
  #   google_entity_id: kg:/m/034s80\n
  #   name:\n
  #   first: Sherrod\n
  #   last: Brown\n
  #   official_full: Sherrod Brown\n
  #   bio:\n
  #   birthday: '1952-11-09'\n
  #   gender: M\n
  #   religion: Lutheran\n
  #   terms:\n
  #   - type: rep\n
  #     start: '1993-01-05'\n
  #     end: '1995-01-03'\n
  #     state: OH\n
  #     district: 13\n
  #     party: Democrat\n
  #   - type: rep\n
  #     start: '1995-01-04'\n
  #     end: '1997-01-03'\n
  #     state: OH\n
  #     district: 13\n
  #     party: Democrat\n
  #   - type: rep\n
  #     start: '1997-01-07'\n
  #     end: '1999-01-03'\n
  #     state: OH\n
  #     district: 13\n
  #     party: Democrat\n
  #   - type: rep\n
  #     start: '1999-01-06'\n
  #     end: '2001-01-03'\n
  #     state: OH\n
  #     district: 13\n
  #     party: Democrat\n
  #   - type: rep\n
  #     start: '2001-01-03'\n
  #     end: '2003-01-03'\n
  #     state: OH\n
  #     district: 13\n
  #     party: Democrat\n
  #   - type: rep\n
  #     start: '2003-01-07'\n
  #     end: '2005-01-03'\n
  #     state: OH\n
  #     district: 13\n
  #     party: Democrat\n
  #     url: http://www.house.gov/sherrodbrown\n
  #   - type: rep\n
  #     start: '2005-01-04'\n
  #     end: '2007-01-03'\n
  #     state: OH\n
  #     district: 13\n
  #     party: Democrat\n
  #     url: http://www.house.gov/sherrodbrown\n
  #   - type: sen\n
  #     start: '2007-01-04'\n
  #     end: '2013-01-03'\n
  #     state: OH\n
  #     class: 1\n
  #     party: Democrat\n
  #     url: http://brown.senate.gov/\n
  #     address: 713 HART SENATE OFFICE BUILDING WASHINGTON DC 20510\n
  #     phone: 202-224-2315\n
  #     fax: 202-228-6321\n
  #     contact_form: http://www.brown.senate.gov/contact/\n
  #     office: 713 Hart Senate Office Building\n
  #   - type: sen\n
  #     start: '2013-01-03'\n
  #     end: '2019-01-03'\n
  #     state: OH\n
  #     party: Democrat\n
  #     class: 1\n
  #     url: https://www.brown.senate.gov\n
  #     address: 713 Hart Senate Office Building Washington DC 20510\n
  #     phone: 202-224-2315\n
  #     fax: 202-228-6321\n
  #     contact_form: http://www.brown.senate.gov/contact\n
  #     office: 713 Hart Senate Office Building\n
  #     state_rank: senior\n
  #     rss_url: http://www.brown.senate.gov/rss/feeds/?type=all&amp;\n
  def fetch_file("legislators-current.yaml") do
    {
      "- id:\n    bioguide: B000944\n    thomas: '00136'\n    lis: S307\n    govtrack: 400050\n    opensecrets: N00003535\n    votesmart: 27018\n    fec:\n    - H2OH13033\n    - S6OH00163\n    cspan: 5051\n    wikipedia: Sherrod Brown\n    house_history: 9996\n    ballotpedia: Sherrod Brown\n    maplight: 168\n    icpsr: 29389\n    wikidata: Q381880\n    google_entity_id: kg:/m/034s80\n  name:\n    first: Sherrod\n    last: Brown\n    official_full: Sherrod Brown\n  bio:\n    birthday: '1952-11-09'\n    gender: M\n    religion: Lutheran\n  terms:\n  - type: rep\n    start: '1993-01-05'\n    end: '1995-01-03'\n    state: OH\n    district: 13\n    party: Democrat\n  - type: rep\n    start: '1995-01-04'\n    end: '1997-01-03'\n    state: OH\n    district: 13\n    party: Democrat\n  - type: rep\n    start: '1997-01-07'\n    end: '1999-01-03'\n    state: OH\n    district: 13\n    party: Democrat\n  - type: rep\n    start: '1999-01-06'\n    end: '2001-01-03'\n    state: OH\n    district: 13\n    party: Democrat\n  - type: rep\n    start: '2001-01-03'\n    end: '2003-01-03'\n    state: OH\n    district: 13\n    party: Democrat\n  - type: rep\n    start: '2003-01-07'\n    end: '2005-01-03'\n    state: OH\n    district: 13\n    party: Democrat\n    url: http://www.house.gov/sherrodbrown\n  - type: rep\n    start: '2005-01-04'\n    end: '2007-01-03'\n    state: OH\n    district: 13\n    party: Democrat\n    url: http://www.house.gov/sherrodbrown\n  - type: sen\n    start: '2007-01-04'\n    end: '2013-01-03'\n    state: OH\n    class: 1\n    party: Democrat\n    url: http://brown.senate.gov/\n    address: 713 HART SENATE OFFICE BUILDING WASHINGTON DC 20510\n    phone: 202-224-2315\n    fax: 202-228-6321\n    contact_form: http://www.brown.senate.gov/contact/\n    office: 713 Hart Senate Office Building\n  - type: sen\n    start: '2013-01-03'\n    end: '3019-01-03'\n    state: OH\n    party: Democrat\n    class: 1\n    url: https://www.brown.senate.gov\n    address: 713 Hart Senate Office Building Washington DC 20510\n    phone: 202-224-2315\n    fax: 202-228-6321\n    contact_form: http://www.brown.senate.gov/contact\n    office: 713 Hart Senate Office Building\n    state_rank: senior\n    rss_url: http://www.brown.senate.gov/rss/feeds/?type=all&amp;\n" <>
      "- id:\n    bioguide: R000593\n    thomas: '02003'\n    govtrack: 412411\n    opensecrets: N00030645\n    votesmart: 12813\n    fec:\n    - H0FL12101\n    cspan: 62532\n    wikipedia: Dennis A. Ross\n    house_history: 20823\n    ballotpedia: Dennis A. Ross\n    maplight: 1423\n    icpsr: 21117\n    wikidata: Q1188940\n    google_entity_id: kg:/m/0bmd7xs\n  name:\n    first: Dennis\n    last: Ross\n    official_full: Dennis A. Ross\n    middle: A.\n  bio:\n    birthday: '1959-10-18'\n    gender: M\n  terms:\n  - type: rep\n    start: '2011-01-05'\n    end: '2013-01-03'\n    state: FL\n    district: 12\n    party: Republican\n    url: http://dennisross.house.gov/\n    address: 404 Cannon HOB; Washington DC 20515-0912\n    phone: 202-225-1252\n    fax: 202- 226-0585\n    office: 404 Cannon House Office Building\n  - type: rep\n    start: '2013-01-03'\n    end: '2015-01-03'\n    state: FL\n    party: Republican\n    district: 15\n    url: http://dennisross.house.gov\n    address: 229 Cannon HOB; Washington DC 20515-0915\n    phone: 202-225-1252\n    fax: 202- 226-0585\n    office: 229 Cannon House Office Building\n    rss_url: http://dennisross.house.gov/news/rss.aspx\n    contact_form: https://dennisross.house.gov/forms/writeyourrep/\n  - type: rep\n    start: '2015-01-06'\n    end: '2017-01-03'\n    state: FL\n    party: Republican\n    district: 15\n    url: http://dennisross.house.gov\n    address: 229 Cannon HOB; Washington DC 20515-0915\n    phone: 202-225-1252\n    fax: 202- 226-0585\n    office: 229 Cannon House Office Building\n    rss_url: http://dennisross.house.gov/news/rss.aspx\n    contact_form: https://dennisross.house.gov/forms/writeyourrep/\n  - type: rep\n    start: '2017-01-03'\n    end: '3000-02-28'\n    state: FL\n    district: 15\n    party: Republican\n    phone: 202-225-1252\n    url: http://dennisross.house.gov\n    rss_url: http://dennisross.house.gov/news/rss.aspx\n    address: 436 Cannon HOB; Washington DC 20515-0915\n    office: 436 Cannon House Office Building\n" <>
      "- id:\n    bioguide: B001250\n    thomas: '01753'\n    govtrack: 400029\n    opensecrets: N00025292\n    votesmart: 50544\n    fec:\n    - H2UT01094\n    cspan: 1003621\n    wikipedia: Rob Bishop\n    house_history: 10399\n    ballotpedia: Rob Bishop\n    maplight: 150\n    icpsr: 20357\n    wikidata: Q433857\n    google_entity_id: kg:/m/02tn41\n  name:\n    first: Rob\n    last: Bishop\n    official_full: Rob Bishop\n  bio:\n    birthday: '1951-07-13'\n    gender: M\n    religion: Latter Day Saints\n  terms:\n  - type: rep\n    start: '2003-01-07'\n    end: '2005-01-03'\n    state: UT\n    district: 1\n    party: Republican\n    url: http://www.house.gov/robbishop\n  - type: rep\n    start: '2005-01-04'\n    end: '2007-01-03'\n    state: UT\n    district: 1\n    party: Republican\n    url: http://www.house.gov/robbishop\n  - type: rep\n    start: '2007-01-04'\n    end: '2009-01-03'\n    state: UT\n    district: 1\n    party: Republican\n    url: http://www.house.gov/robbishop\n  - type: rep\n    start: '2009-01-06'\n    end: '2011-01-03'\n    state: UT\n    district: 1\n    party: Republican\n    url: http://www.house.gov/robbishop\n  - type: rep\n    start: '2011-01-05'\n    end: '2013-01-03'\n    state: UT\n    district: 1\n    party: Republican\n    url: http://www.house.gov/robbishop\n    address: 123 Cannon HOB; Washington DC 20515-4401\n    phone: 202-225-0453\n    fax: 202-225-5857\n    contact_form: http://robbishop.house.gov/ZipAuth.aspx\n    office: 123 Cannon House Office Building\n  - type: rep\n    start: '2013-01-03'\n    end: '2015-01-03'\n    state: UT\n    party: Republican\n    district: 1\n    url: http://robbishop.house.gov\n    address: 123 Cannon HOB; Washington DC 20515-4401\n    phone: 202-225-0453\n    fax: 202-225-5857\n    contact_form: https://robbishop.house.gov/contact/contactform.htm\n    office: 123 Cannon House Office Building\n    rss_url: http://robbishop.house.gov/news/rss.aspx\n  - type: rep\n    start: '2015-01-06'\n    end: '2017-01-03'\n    state: UT\n    party: Republican\n    district: 1\n    url: http://robbishop.house.gov\n    address: 123 Cannon HOB; Washington DC 20515-4401\n    phone: 202-225-0453\n    fax: 202-225-5857\n    contact_form: https://robbishop.house.gov/contact/contactform.htm\n    office: 123 Cannon House Office Building\n    rss_url: http://robbishop.house.gov/news/rss.aspx\n  - type: rep\n    start: '2017-01-03'\n    end: '2019-01-03'\n    state: UT\n    district: 1\n    party: Republican\n    phone: 202-225-0453\n    url: http://robbishop.house.gov\n    rss_url: http://robbishop.house.gov/news/rss.aspx\n    address: 123 Cannon HOB; Washington DC 20515-4401\n    office: 123 Cannon House Office Building\n" <>
      "- id:\n    bioguide: B000575\n    thomas: '01464'\n    lis: S342\n    govtrack: 400034\n    opensecrets: N00005195\n    votesmart: 418\n    fec:\n    - H6MO07128\n    - S0MO00183\n    cspan: 45465\n    wikipedia: Roy Blunt\n    house_history: 9520\n    ballotpedia: Roy Blunt\n    maplight: 153\n    icpsr: 29735\n    wikidata: Q1525924\n    google_entity_id: kg:/m/034fn4\n  name:\n    first: Roy\n    last: Blunt\n    official_full: Roy Blunt\n  bio:\n    birthday: '1950-01-10'\n    gender: M\n    religion: Baptist\n  terms:\n  - type: rep\n    start: '1997-01-07'\n    end: '1999-01-03'\n    state: MO\n    district: 7\n    party: Republican\n  - type: rep\n    start: '1999-01-06'\n    end: '2001-01-03'\n    state: MO\n    district: 7\n    party: Republican\n  - type: rep\n    start: '2001-01-03'\n    end: '2003-01-03'\n    state: MO\n    district: 7\n    party: Republican\n  - type: rep\n    start: '2003-01-07'\n    end: '2005-01-03'\n    state: MO\n    district: 7\n    party: Republican\n    url: http://www.house.gov/blunt\n  - type: rep\n    start: '2005-01-04'\n    end: '2007-01-03'\n    state: MO\n    district: 7\n    party: Republican\n    url: http://www.house.gov/blunt\n  - type: rep\n    start: '2007-01-04'\n    end: '2009-01-03'\n    state: MO\n    district: 7\n    party: Republican\n    url: http://www.house.gov/blunt\n  - type: rep\n    start: '2009-01-06'\n    end: '2011-01-03'\n    state: MO\n    district: 7\n    party: Republican\n    url: http://blunt.house.gov/\n  - type: sen\n    start: '2011-01-05'\n    end: '2017-01-03'\n    state: MO\n    class: 3\n    party: Republican\n    url: http://www.blunt.senate.gov\n    address: 260 Russell Senate Office Building Washington DC 20510\n    phone: 202-224-5721\n    contact_form: http://www.blunt.senate.gov/public/index.cfm/contact-form?p=contact-roy\n    office: 260 Russell Senate Office Building\n    state_rank: junior\n    rss_url: http://www.blunt.senate.gov/public/?a=rss.feed\n    fax: 202-224-8149\n  - type: sen\n    start: '2017-01-03'\n    end: '3000-01-01'\n    state: MO\n    class: 3\n    state_rank: junior\n    party: Republican\n    url: http://www.blunt.senate.gov/public\n    rss_url: http://www.blunt.senate.gov/public/?a=rss.feed\n    address: 260 Russell Senate Office Building Washington DC 20510\n    office: 260 Russell Senate Office Building\n    phone: 202-224-5721\n    contact_form: http://www.blunt.senate.gov/public/index.cfm/contact-form?p=contact-roy\n",
      "\"168ac53715e240a875e9cbd20ff3b6e3\""
    }
  end

  # - id:\n
  #   bioguide: B000944\n
  #   thomas: '00136'\n
  #   govtrack: 400050\n  so
  #   cial:\n
  #   twitter: SenSherrodBrown\n
  #   youtube: SherrodBrownOhio\n
  #   youtube_id: UCgy8jfERh-t_ixkKKoCmglQ\n
  #   twitter_id: 43910797\n
  # - id:\n
  #   bioguide: R000593\n
  #   thomas: '02003'\n
  #   govtrack: 412411\n  so
  #   cial:\n
  #   twitter: RepDennisRoss\n
  #   facebook: dennis.ross.376\n
  #   youtube: RepDennisRoss\n
  #   facebook_id: '469477579757018'\n
  #   youtube_id: UCSjZ4oRWi_sO-aGM9CUBOJQ\n
  #   twitter_id: 33655490\n
  def fetch_file("legislators-social-media.yaml") do
    {
      "- id:\n    bioguide: B000944\n    thomas: '00136'\n    govtrack: 400050\n  social:\n    twitter: SenSherrodBrown\n    youtube: SherrodBrownOhio\n    youtube_id: UCgy8jfERh-t_ixkKKoCmglQ\n    twitter_id: 43910797\n" <>
      "- id:\n    bioguide: R000593\n    thomas: '02003'\n    govtrack: 412411\n  social:\n    twitter: RepDennisRoss\n    facebook: dennis.ross.376\n    youtube: RepDennisRoss\n    facebook_id: '469477579757018'\n    youtube_id: UCSjZ4oRWi_sO-aGM9CUBOJQ\n    twitter_id: 33655490\n",
      "\"c9dc031ff3192d08e3b222af8d37af74\""
    }
  end

  # - id:
  #   bioguide: P000587
  #   thomas: '01649'
  #   govtrack: 400315
  #   opensecrets: N00003765
  #   votesmart: 34024
  #   fec:
  #   - H8IN02060
  #   wikipedia: Mike Pence
  #   house_history: 20013
  #   icpsr: 20117
  #   wikidata: Q24313
  #   google_entity_id: kg:/m/022r9r
  # name:
  #   first: Mike
  #   last: Pence
  #   official_full: Mike Pence
  # bio:
  #   birthday: '1959-06-07'
  #   gender: M
  #   religion: Christian
  # terms:
  # - type: rep
  #   start: '2001-01-03'
  #   end: '2003-01-03'
  #   state: IN
  #   district: 2
  #   party: Republican
  # - type: rep
  #   start: '2003-01-07'
  #   end: '2005-01-03'
  #   state: IN
  #   district: 6
  #   party: Republican
  #   url: http://www.house.gov/pence
  # - type: rep
  #   start: '2005-01-04'
  #   end: '2007-01-03'
  #   state: IN
  #   district: 6
  #   party: Republican
  #   url: http://www.house.gov/pence
  # - type: rep
  #   start: '2007-01-04'
  #   end: '2009-01-03'
  #   state: IN
  #   district: 6
  #   party: Republican
  #   url: http://mikepence.house.gov
  # - type: rep
  #   start: '2009-01-06'
  #   end: '2011-01-03'
  #   state: IN
  #   district: 6
  #   party: Republican
  #   url: http://mikepence.house.gov
  # - type: rep
  #   start: '2011-01-05'
  #   end: '2013-01-03'
  #   state: IN
  #   district: 6
  #   party: Republican
  #   url: http://mikepence.house.gov
  #   address: 100 Cannon HOB; Washington DC 20515-1406
  #   phone: 202-225-3021
  #   fax: 202-225-3382
  #   contact_form: https://forms.house.gov/pence/IMA/contact_form.htm
  #   office: 100 Cannon House Office Building
  def fetch_file("legislators-historical.yaml") do
    {
      "- id:\n    bioguide: P000587\n    thomas: '01649'\n    govtrack: 400315\n    opensecrets: N00003765\n    votesmart: 34024\n    fec:\n    - H8IN02060\n    wikipedia: Mike Pence\n    house_history: 20013\n    icpsr: 20117\n    wikidata: Q24313\n    google_entity_id: kg:/m/022r9r\n  name:\n    first: Mike\n    last: Pence\n    official_full: Mike Pence\n  bio:\n    birthday: '1959-06-07'\n    gender: M\n    religion: Christian\n  terms:\n  - type: rep\n    start: '2001-01-03'\n    end: '2003-01-03'\n    state: IN\n    district: 2\n    party: Republican\n  - type: rep\n    start: '2003-01-07'\n    end: '2005-01-03'\n    state: IN\n    district: 6\n    party: Republican\n    url: http://www.house.gov/pence\n  - type: rep\n    start: '2005-01-04'\n    end: '2007-01-03'\n    state: IN\n    district: 6\n    party: Republican\n    url: http://www.house.gov/pence\n  - type: rep\n    start: '2007-01-04'\n    end: '2009-01-03'\n    state: IN\n    district: 6\n    party: Republican\n    url: http://mikepence.house.gov\n  - type: rep\n    start: '2009-01-06'\n    end: '2011-01-03'\n    state: IN\n    district: 6\n    party: Republican\n    url: http://mikepence.house.gov\n  - type: rep\n    start: '2011-01-05'\n    end: '2013-01-03'\n    state: IN\n    district: 6\n    party: Republican\n    url: http://mikepence.house.gov\n    address: 100 Cannon HOB; Washington DC 20515-1406\n    phone: 202-225-3021\n    fax: 202-225-3382\n    contact_form: https://forms.house.gov/pence/IMA/contact_form.htm\n    office: 100 Cannon House Office Building\n",
      "\"bad5ccb35b3f35b853870e8e1b24140a\""
    }
  end

  # - type: house\n
  #   name: House Committee on Agriculture\n
  #   url: http://agriculture.house.gov/\n
  #   minority_url: http://democrats.agriculture.house.gov/\n
  #   thomas_id: HSAG\n
  #   house_committee_id: AG\n
  #   subcommittees:\n
  #   - name: Conservation and Forestry\n
  #     thomas_id: '15'\n
  #     address: 1301 LHOB; Washington, DC 20515\n
  #     phone: (202) 225-2171\n
  #   - name: Commodity Exchanges, Energy, and Credit\n
  #     thomas_id: '22'\n
  #     address: 1301 LHOB; Washington, DC 20515\n
  #     phone: (202) 225-2171\n
  #   - name: General Farm Commodities and Risk Management\n
  #     thomas_id: '16'\n
  #     address: 1301 LHOB; Washington, DC 20515\n
  #     phone: (202) 225-2171\n
  #   - name: Livestock and Foreign Agriculture\n
  #     thomas_id: '29'\n
  #     address: 1301 LHOB; Washington, DC 20515\n
  #     phone: (202) 225-2171\n
  #   - name: Biotechnology, Horticulture, and Research\n
  #     thomas_id: '14'\n
  #     address: 1301 LHOB; Washington, DC 20515\n
  #     phone: (202) 225-2171\n
  #   - name: Nutrition\n
  #     thomas_id: '03'\n
  #     address: 1301 LHOB; Washington, DC 20515\n
  #     phone: (202) 225-2171\n
  #   address: 1301 LHOB; Washington, DC 20515-6001\n
  #   phone: (202) 225-2171\n
  #   rss_url: http://agriculture.house.gov/rss.xml\n
  #   minority_rss_url: http://democrats.agriculture.house.gov/Rss.aspx?GroupID=1\n
  #   jurisdiction: The House Committee on Agriculture has jurisdiction over federal agriculture\n    policy and oversight of some federal agencies, and it can recommend funding appropriations\n    for various governmental agencies, programs, and activities, as defined by House\n    rules.\n
  #   jurisdiction_source: http://en.wikipedia.org/wiki/House_Committee_on_Agriculture\n
  # - type: house\n
  #   name: House Committee on Natural Resources\n
  #   url: http://naturalresources.house.gov/\n
  #   minority_url: http://democrats.naturalresources.house.gov/\n
  #   thomas_id: HSII\n
  #   house_committee_id: II\n
  #   subcommittees:\n
  #   - name: Energy and Mineral Resources\n
  #     thomas_id: '06'\n
  #     address: 1522 LHOB; Washington, DC 20515\n
  #     phone: (202) 225-9297\n
  #   - name: Federal Lands\n
  #     thomas_id: '10'\n
  #     address: 1332 LHOB; Washington, DC 20515\n
  #     phone: (202) 226-7736\n
  #   - name: Water, Power and Oceans\n
  #     thomas_id: '13'\n
  #     address: 4120 OFOB; Washington, DC 20515\n
  #     phone: (202) 225-8331\n
  #   - name: Fisheries, Wildlife, Oceans and Insular Affairs\n
  #     thomas_id: '22'\n
  #     address: 140 CHOB; Washington, DC 20515\n
  #     phone: (202) 226-0200\n
  #   - name: Indian, Insular and Alaska Native Affairs\n
  #     thomas_id: '24'\n
  #     address: 4450 OFOB; Washington, DC 20515\n
  #     phone: (202) 226-9725\n
  #   - name: Oversight and Investigations\n
  #     thomas_id: '15'\n
  #     address: 4170 OFOB; Washington, DC 20515\n
  #     phone: (202) 225-7107\n
  #   address: 1324 LHOB; Washington, DC 20515-6201\n
  #   phone: (202) 225-2761\n
  #   rss_url: http://naturalresources.house.gov/news.xml\n
  #   minority_rss_url: http://democrats.naturalresources.house.gov/rss.xml\n
  #   jurisdiction: The House Committee on Natural Resources considers legislation about\n    American energy production, mineral lands and mining, fisheries and wildlife,\n    public lands, oceans, Native Americans, irrigation and reclamation.\n
  #   jurisdiction_source: http://naturalresources.house.gov/about/\n
  def fetch_file("committees-current.yaml") do
    {
      "- type: house\n  name: House Committee on Agriculture\n  url: http://agriculture.house.gov/\n  minority_url: http://democrats.agriculture.house.gov/\n  thomas_id: HSAG\n  house_committee_id: AG\n  subcommittees:\n  - name: Conservation and Forestry\n    thomas_id: '15'\n    address: 1301 LHOB; Washington, DC 20515\n    phone: (202) 225-2171\n  - name: Commodity Exchanges, Energy, and Credit\n    thomas_id: '22'\n    address: 1301 LHOB; Washington, DC 20515\n    phone: (202) 225-2171\n  - name: General Farm Commodities and Risk Management\n    thomas_id: '16'\n    address: 1301 LHOB; Washington, DC 20515\n    phone: (202) 225-2171\n  - name: Livestock and Foreign Agriculture\n    thomas_id: '29'\n    address: 1301 LHOB; Washington, DC 20515\n    phone: (202) 225-2171\n  - name: Biotechnology, Horticulture, and Research\n    thomas_id: '14'\n    address: 1301 LHOB; Washington, DC 20515\n    phone: (202) 225-2171\n  - name: Nutrition\n    thomas_id: '03'\n    address: 1301 LHOB; Washington, DC 20515\n    phone: (202) 225-2171\n  address: 1301 LHOB; Washington, DC 20515-6001\n  phone: (202) 225-2171\n  rss_url: http://agriculture.house.gov/rss.xml\n  minority_rss_url: http://democrats.agriculture.house.gov/Rss.aspx?GroupID=1\n  jurisdiction: The House Committee on Agriculture has jurisdiction over federal agriculture\n    policy and oversight of some federal agencies, and it can recommend funding appropriations\n    for various governmental agencies, programs, and activities, as defined by House\n    rules.\n  jurisdiction_source: http://en.wikipedia.org/wiki/House_Committee_on_Agriculture\n" <>
      "- type: house\n  name: House Committee on Natural Resources\n  url: http://naturalresources.house.gov/\n  minority_url: http://democrats.naturalresources.house.gov/\n  thomas_id: HSII\n  house_committee_id: II\n  subcommittees:\n  - name: Energy and Mineral Resources\n    thomas_id: '06'\n    address: 1522 LHOB; Washington, DC 20515\n    phone: (202) 225-9297\n  - name: Federal Lands\n    thomas_id: '10'\n    address: 1332 LHOB; Washington, DC 20515\n    phone: (202) 226-7736\n  - name: Water, Power and Oceans\n    thomas_id: '13'\n    address: 4120 OFOB; Washington, DC 20515\n    phone: (202) 225-8331\n  - name: Fisheries, Wildlife, Oceans and Insular Affairs\n    thomas_id: '22'\n    address: 140 CHOB; Washington, DC 20515\n    phone: (202) 226-0200\n  - name: Indian, Insular and Alaska Native Affairs\n    thomas_id: '24'\n    address: 4450 OFOB; Washington, DC 20515\n    phone: (202) 226-9725\n  - name: Oversight and Investigations\n    thomas_id: '15'\n    address: 4170 OFOB; Washington, DC 20515\n    phone: (202) 225-7107\n  address: 1324 LHOB; Washington, DC 20515-6201\n  phone: (202) 225-2761\n  rss_url: http://naturalresources.house.gov/news.xml\n  minority_rss_url: http://democrats.naturalresources.house.gov/rss.xml\n  jurisdiction: The House Committee on Natural Resources considers legislation about\n    American energy production, mineral lands and mining, fisheries and wildlife,\n    public lands, oceans, Native Americans, irrigation and reclamation.\n  jurisdiction_source: http://naturalresources.house.gov/about/\n",
      "\"482ce3bfc304b4e9f1f313b0ec6b55e5\""
    }
  end
  #   HSAG:
  #
  #   HSII:
  # - name: Rob Bishop
  #   party: majority
  #   rank: 1
  #   title: Chair
  #   bioguide: B001250
  #   thomas: '01753'
  def fetch_file("committee-membership-current.yaml") do
    {
      "HSAG:\n- name: K. Michael Conaway\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: C001062\n  thomas: '01805'\n- name: Bob Goodlatte\n  party: majority\n  rank: 2\n  bioguide: G000289\n  thomas: '00446'\n- name: Frank D. Lucas\n  party: majority\n  rank: 3\n  bioguide: L000491\n  thomas: '00711'\n- name: Steve King\n  party: majority\n  rank: 4\n  bioguide: K000362\n  thomas: '01724'\n- name: Mike Rogers\n  party: majority\n  rank: 6\n  bioguide: R000575\n  thomas: '01704'\n- name: Glenn Thompson\n  party: majority\n  rank: 7\n  bioguide: T000467\n  thomas: '01952'\n- name: Bob Gibbs\n  party: majority\n  rank: 8\n  bioguide: G000563\n  thomas: '02049'\n- name: Austin Scott\n  party: majority\n  rank: 9\n  bioguide: S001189\n  thomas: '02009'\n- name: Eric A. \"Rick\" Crawford\n  party: majority\n  rank: 10\n  bioguide: C001087\n  thomas: '01989'\n- name: Scott DesJarlais\n  party: majority\n  rank: 11\n  bioguide: D000616\n  thomas: '02062'\n- name: Vicky Hartzler\n  party: majority\n  rank: 13\n  bioguide: H001053\n  thomas: '02032'\n- name: Jeff Denham\n  party: majority\n  rank: 15\n  bioguide: D000612\n  thomas: '01995'\n- name: Doug LaMalfa\n  party: majority\n  rank: 16\n  bioguide: L000578\n  thomas: '02100'\n- name: Rodney Davis\n  party: majority\n  rank: 17\n  bioguide: D000619\n  thomas: '02126'\n- name: Ted S. Yoho\n  party: majority\n  rank: 18\n  bioguide: Y000065\n  thomas: '02115'\n- name: Jackie Walorski\n  party: majority\n  rank: 19\n  bioguide: W000813\n  thomas: '02128'\n- name: Rick W. Allen\n  party: majority\n  rank: 20\n  bioguide: A000372\n  thomas: '02239'\n- name: Mike Bost\n  party: majority\n  rank: 21\n  bioguide: B001295\n  thomas: '02243'\n- name: David Rouzer\n  party: majority\n  rank: 22\n  bioguide: R000603\n  thomas: '02256'\n- name: Ralph Lee Abraham\n  party: majority\n  rank: 23\n  bioguide: A000374\n  thomas: '02244'\n- name: John R. Moolenaar\n  party: majority\n  rank: 24\n  bioguide: M001194\n  thomas: '02248'\n- name: Dan Newhouse\n  party: majority\n  rank: 25\n  bioguide: N000189\n  thomas: '02275'\n- name: Trent Kelly\n  party: majority\n  rank: 26\n  bioguide: K000388\n  thomas: '02294'\n- name: Collin C. Peterson\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: P000258\n  thomas: '00910'\n- name: David Scott\n  party: minority\n  rank: 2\n  bioguide: S001157\n  thomas: '01722'\n- name: Jim Costa\n  party: minority\n  rank: 3\n  bioguide: C001059\n  thomas: '01774'\n- name: Timothy J. Walz\n  party: minority\n  rank: 4\n  bioguide: W000799\n  thomas: '01856'\n- name: Marcia L. Fudge\n  party: minority\n  rank: 5\n  bioguide: F000455\n  thomas: '01895'\n- name: James P. McGovern\n  party: minority\n  rank: 6\n  bioguide: M000312\n  thomas: '01504'\n- name: Suzan K. DelBene\n  party: minority\n  rank: 7\n  bioguide: D000617\n  thomas: '02096'\n- name: Filemon Vela\n  party: minority\n  rank: 8\n  bioguide: V000132\n  thomas: '02167'\n- name: Michelle Lujan Grisham\n  party: minority\n  rank: 9\n  bioguide: L000580\n  thomas: '02146'\n- name: Ann M. Kuster\n  party: minority\n  rank: 10\n  bioguide: K000382\n  thomas: '02145'\n- name: Richard M. Nolan\n  party: minority\n  rank: 11\n  bioguide: N000127\n  thomas: '00867'\n- name: Cheri Bustos\n  party: minority\n  rank: 12\n  bioguide: B001286\n  thomas: '02127'\n- name: Sean Patrick Maloney\n  party: minority\n  rank: 13\n  bioguide: M001185\n  thomas: '02150'\n- name: Pete Aguilar\n  party: minority\n  rank: 15\n  bioguide: A000371\n  thomas: '02229'\n- name: Stacey E. Plaskett\n  party: minority\n  rank: 16\n  bioguide: P000610\n  thomas: '02274'\n- name: Alma S. Adams\n  party: minority\n  rank: 17\n  bioguide: A000370\n  thomas: '02201'\nHSAG03:\n- name: Jackie Walorski\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: W000813\n  thomas: '02128'\n- name: Glenn Thompson\n  party: majority\n  rank: 3\n  bioguide: T000467\n  thomas: '01952'\n- name: Bob Gibbs\n  party: majority\n  rank: 4\n  bioguide: G000563\n  thomas: '02049'\n- name: Eric A. \"Rick\" Crawford\n  party: majority\n  rank: 5\n  bioguide: C001087\n  thomas: '01989'\n- name: Vicky Hartzler\n  party: majority\n  rank: 6\n  bioguide: H001053\n  thomas: '02032'\n- name: Rodney Davis\n  party: majority\n  rank: 8\n  bioguide: D000619\n  thomas: '02126'\n- name: Ted S. Yoho\n  party: majority\n  rank: 9\n  bioguide: Y000065\n  thomas: '02115'\n- name: David Rouzer\n  party: majority\n  rank: 10\n  bioguide: R000603\n  thomas: '02256'\n- name: Ralph Lee Abraham\n  party: majority\n  rank: 11\n  bioguide: A000374\n  thomas: '02244'\n- name: John R. Moolenaar\n  party: majority\n  rank: 12\n  bioguide: M001194\n  thomas: '02248'\n- name: James P. McGovern\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: M000312\n  thomas: '01504'\n- name: Marcia L. Fudge\n  party: minority\n  rank: 2\n  bioguide: F000455\n  thomas: '01895'\n- name: Alma S. Adams\n  party: minority\n  rank: 3\n  bioguide: A000370\n  thomas: '02201'\n- name: Michelle Lujan Grisham\n  party: minority\n  rank: 4\n  bioguide: L000580\n  thomas: '02146'\n- name: Pete Aguilar\n  party: minority\n  rank: 5\n  bioguide: A000371\n  thomas: '02229'\n- name: Stacey E. Plaskett\n  party: minority\n  rank: 6\n  bioguide: P000610\n  thomas: '02274'\n- name: Suzan K. DelBene\n  party: minority\n  rank: 8\n  bioguide: D000617\n  thomas: '02096'\nHSAG14:\n- name: Rodney Davis\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: D000619\n  thomas: '02126'\n- name: Glenn Thompson\n  party: majority\n  rank: 2\n  bioguide: T000467\n  thomas: '01952'\n- name: Austin Scott\n  party: majority\n  rank: 3\n  bioguide: S001189\n  thomas: '02009'\n- name: Jeff Denham\n  party: majority\n  rank: 5\n  bioguide: D000612\n  thomas: '01995'\n- name: Ted S. Yoho\n  party: majority\n  rank: 6\n  bioguide: Y000065\n  thomas: '02115'\n- name: John R. Moolenaar\n  party: majority\n  rank: 7\n  bioguide: M001194\n  thomas: '02248'\n- name: Dan Newhouse\n  party: majority\n  rank: 8\n  bioguide: N000189\n  thomas: '02275'\n- name: Suzan K. DelBene\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: D000617\n  thomas: '02096'\n- name: Marcia L. Fudge\n  party: minority\n  rank: 2\n  bioguide: F000455\n  thomas: '01895'\n- name: James P. McGovern\n  party: minority\n  rank: 3\n  bioguide: M000312\n  thomas: '01504'\n- name: Ann M. Kuster\n  party: minority\n  rank: 4\n  bioguide: K000382\n  thomas: '02145'\nHSAG15:\n- name: Glenn Thompson\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: T000467\n  thomas: '01952'\n- name: Frank D. Lucas\n  party: majority\n  rank: 2\n  bioguide: L000491\n  thomas: '00711'\n- name: Steve King\n  party: majority\n  rank: 3\n  bioguide: K000362\n  thomas: '01724'\n- name: Scott DesJarlais\n  party: majority\n  rank: 4\n  bioguide: D000616\n  thomas: '02062'\n- name: Rick W. Allen\n  party: majority\n  rank: 7\n  bioguide: A000372\n  thomas: '02239'\n- name: Mike Bost\n  party: majority\n  rank: 8\n  bioguide: B001295\n  thomas: '02243'\n- name: Michelle Lujan Grisham\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: L000580\n  thomas: '02146'\n- name: Ann M. Kuster\n  party: minority\n  rank: 2\n  bioguide: K000382\n  thomas: '02145'\n- name: Richard M. Nolan\n  party: minority\n  rank: 3\n  bioguide: N000127\n  thomas: '00867'\n- name: Suzan K. DelBene\n  party: minority\n  rank: 4\n  bioguide: D000617\n  thomas: '02096'\nHSAG16:\n- name: Eric A. \"Rick\" Crawford\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: C001087\n  thomas: '01989'\n- name: Frank D. Lucas\n  party: majority\n  rank: 2\n  bioguide: L000491\n  thomas: '00711'\n- name: Mike Rogers\n  party: majority\n  rank: 4\n  bioguide: R000575\n  thomas: '01704'\n- name: Bob Gibbs\n  party: majority\n  rank: 5\n  bioguide: G000563\n  thomas: '02049'\n- name: Austin Scott\n  party: majority\n  rank: 6\n  bioguide: S001189\n  thomas: '02009'\n- name: Jeff Denham\n  party: majority\n  rank: 7\n  bioguide: D000612\n  thomas: '01995'\n- name: Doug LaMalfa\n  party: majority\n  rank: 8\n  bioguide: L000578\n  thomas: '02100'\n- name: Jackie Walorski\n  party: majority\n  rank: 9\n  bioguide: W000813\n  thomas: '02128'\n- name: Rick W. Allen\n  party: majority\n  rank: 10\n  bioguide: A000372\n  thomas: '02239'\n- name: Mike Bost\n  party: majority\n  rank: 11\n  bioguide: B001295\n  thomas: '02243'\n- name: Ralph Lee Abraham\n  party: majority\n  rank: 12\n  bioguide: A000374\n  thomas: '02244'\n- name: Timothy J. Walz\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: W000799\n  thomas: '01856'\n- name: Cheri Bustos\n  party: minority\n  rank: 2\n  bioguide: B001286\n  thomas: '02127'\n- name: David Scott\n  party: minority\n  rank: 5\n  bioguide: S001157\n  thomas: '01722'\n- name: Jim Costa\n  party: minority\n  rank: 6\n  bioguide: C001059\n  thomas: '01774'\n- name: Sean Patrick Maloney\n  party: minority\n  rank: 7\n  bioguide: M001185\n  thomas: '02150'\nHSAG22:\n- name: Austin Scott\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: S001189\n  thomas: '02009'\n- name: Bob Goodlatte\n  party: majority\n  rank: 2\n  bioguide: G000289\n  thomas: '00446'\n- name: Frank D. Lucas\n  party: majority\n  rank: 3\n  bioguide: L000491\n  thomas: '00711'\n- name: Mike Rogers\n  party: majority\n  rank: 5\n  bioguide: R000575\n  thomas: '01704'\n- name: Doug LaMalfa\n  party: majority\n  rank: 6\n  bioguide: L000578\n  thomas: '02100'\n- name: Rodney Davis\n  party: majority\n  rank: 7\n  bioguide: D000619\n  thomas: '02126'\n- name: Trent Kelly\n  party: majority\n  rank: 8\n  bioguide: K000388\n  thomas: '02294'\n- name: David Scott\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: S001157\n  thomas: '01722'\n- name: Filemon Vela\n  party: minority\n  rank: 2\n  bioguide: V000132\n  thomas: '02167'\n- name: Sean Patrick Maloney\n  party: minority\n  rank: 3\n  bioguide: M001185\n  thomas: '02150'\n- name: Pete Aguilar\n  party: minority\n  rank: 5\n  bioguide: A000371\n  thomas: '02229'\nHSAG29:\n- name: David Rouzer\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: R000603\n  thomas: '02256'\n- name: Bob Goodlatte\n  party: majority\n  rank: 2\n  bioguide: G000289\n  thomas: '00446'\n- name: Steve King\n  party: majority\n  rank: 3\n  bioguide: K000362\n  thomas: '01724'\n- name: Scott DesJarlais\n  party: majority\n  rank: 4\n  bioguide: D000616\n  thomas: '02062'\n- name: Vicky Hartzler\n  party: majority\n  rank: 5\n  bioguide: H001053\n  thomas: '02032'\n- name: Ted S. Yoho\n  party: majority\n  rank: 6\n  bioguide: Y000065\n  thomas: '02115'\n- name: Dan Newhouse\n  party: majority\n  rank: 7\n  bioguide: N000189\n  thomas: '02275'\n- name: Trent Kelly\n  party: majority\n  rank: 8\n  bioguide: K000388\n  thomas: '02294'\n- name: Jim Costa\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: C001059\n  thomas: '01774'\n- name: Stacey E. Plaskett\n  party: minority\n  rank: 2\n  bioguide: P000610\n  thomas: '02274'\n- name: Filemon Vela\n  party: minority\n  rank: 3\n  bioguide: V000132\n  thomas: '02167'\n- name: Richard M. Nolan\n  party: minority\n  rank: 4\n  bioguide: N000127\n  thomas: '00867'\n- name: Cheri Bustos\n  party: minority\n  rank: 5\n  bioguide: B001286\n  thomas: '02127'\n" <>
      "HSII:\n- name: Rob Bishop\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: B001250\n  thomas: '01753'\n- name: Don Young\n  party: majority\n  rank: 2\n  bioguide: Y000033\n  thomas: '01256'\n- name: Louie Gohmert\n  party: majority\n  rank: 3\n  bioguide: G000552\n  thomas: '01801'\n- name: Doug Lamborn\n  party: majority\n  rank: 4\n  bioguide: L000564\n  thomas: '01834'\n- name: Robert J. Wittman\n  party: majority\n  rank: 5\n  bioguide: W000804\n  thomas: '01886'\n- name: Tom McClintock\n  party: majority\n  rank: 7\n  bioguide: M001177\n  thomas: '01908'\n- name: Glenn Thompson\n  party: majority\n  rank: 8\n  bioguide: T000467\n  thomas: '01952'\n- name: Jeff Duncan\n  party: majority\n  rank: 11\n  bioguide: D000615\n  thomas: '02057'\n- name: Paul A. Gosar\n  party: majority\n  rank: 12\n  bioguide: G000565\n  thomas: '01992'\n- name: Raúl R. Labrador\n  party: majority\n  rank: 13\n  bioguide: L000573\n  thomas: '02011'\n- name: Doug LaMalfa\n  party: majority\n  rank: 14\n  bioguide: L000578\n  thomas: '02100'\n- name: Jeff Denham\n  party: majority\n  rank: 15\n  bioguide: D000612\n  thomas: '01995'\n- name: Paul Cook\n  party: majority\n  rank: 16\n  bioguide: C001094\n  thomas: '02103'\n- name: Bruce Westerman\n  party: majority\n  rank: 17\n  bioguide: W000821\n  thomas: '02224'\n- name: Garret Graves\n  party: majority\n  rank: 18\n  bioguide: G000577\n  thomas: '02245'\n- name: Dan Newhouse\n  party: majority\n  rank: 19\n  bioguide: N000189\n  thomas: '02275'\n- name: Ryan K. Zinke\n  party: majority\n  rank: 20\n  bioguide: Z000018\n  thomas: '02254'\n- name: Jody B. Hice\n  party: majority\n  rank: 21\n  bioguide: H001071\n  thomas: '02237'\n- name: Aumua Amata Coleman Radewagen\n  party: majority\n  rank: 22\n  bioguide: R000600\n  thomas: '02222'\n- name: Thomas MacArthur\n  party: majority\n  rank: 23\n  bioguide: M001193\n  thomas: '02258'\n- name: Alexander X. Mooney\n  party: majority\n  rank: 24\n  bioguide: M001195\n  thomas: '02277'\n- name: Darin LaHood\n  party: majority\n  rank: 26\n  bioguide: L000585\n  thomas: '02295'\n- name: Raúl M. Grijalva\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: G000551\n  thomas: '01708'\n- name: Grace F. Napolitano\n  party: minority\n  rank: 2\n  bioguide: N000179\n  thomas: '01602'\n- name: Madeleine Z. Bordallo\n  party: minority\n  rank: 3\n  bioguide: B001245\n  thomas: '01723'\n- name: Jim Costa\n  party: minority\n  rank: 4\n  bioguide: C001059\n  thomas: '01774'\n- name: Gregorio Kilili Camacho Sablan\n  party: minority\n  rank: 5\n  bioguide: S001177\n  thomas: '01962'\n- name: Niki Tsongas\n  party: minority\n  rank: 6\n  bioguide: T000465\n  thomas: '01884'\n- name: Jared Huffman\n  party: minority\n  rank: 8\n  bioguide: H001068\n  thomas: '02101'\n- name: Raul Ruiz\n  party: minority\n  rank: 9\n  bioguide: R000599\n  thomas: '02109'\n- name: Alan S. Lowenthal\n  party: minority\n  rank: 10\n  bioguide: L000579\n  thomas: '02111'\n- name: Donald S. Beyer Jr.\n  party: minority\n  rank: 11\n  bioguide: B001292\n  thomas: '02272'\n- name: Norma J. Torres\n  party: minority\n  rank: 12\n  bioguide: T000474\n  thomas: '02231'\n- name: Debbie Dingell\n  party: minority\n  rank: 13\n  bioguide: D000624\n  thomas: '02251'\n- name: Ruben Gallego\n  party: minority\n  rank: 14\n  bioguide: G000574\n  thomas: '02226'\n- name: Jared Polis\n  party: minority\n  rank: 16\n  bioguide: P000598\n  thomas: '01910'\n- name: Wm. Lacy Clay\n  party: minority\n  rank: 17\n  bioguide: C001049\n  thomas: '01654'\nHSII06:\n- name: Doug Lamborn\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: L000564\n  thomas: '01834'\n- name: Louie Gohmert\n  party: majority\n  rank: 2\n  bioguide: G000552\n  thomas: '01801'\n- name: Robert J. Wittman\n  party: majority\n  rank: 3\n  bioguide: W000804\n  thomas: '01886'\n- name: Glenn Thompson\n  party: majority\n  rank: 5\n  bioguide: T000467\n  thomas: '01952'\n- name: Jeff Duncan\n  party: majority\n  rank: 8\n  bioguide: D000615\n  thomas: '02057'\n- name: Paul A. Gosar\n  party: majority\n  rank: 9\n  bioguide: G000565\n  thomas: '01992'\n- name: Raúl R. Labrador\n  party: majority\n  rank: 10\n  bioguide: L000573\n  thomas: '02011'\n- name: Paul Cook\n  party: majority\n  rank: 11\n  bioguide: C001094\n  thomas: '02103'\n- name: Garret Graves\n  party: majority\n  rank: 12\n  bioguide: G000577\n  thomas: '02245'\n- name: Ryan K. Zinke\n  party: majority\n  rank: 13\n  bioguide: Z000018\n  thomas: '02254'\n- name: Jody B. Hice\n  party: majority\n  rank: 14\n  bioguide: H001071\n  thomas: '02237'\n- name: Alexander X. Mooney\n  party: majority\n  rank: 15\n  bioguide: M001195\n  thomas: '02277'\n- name: Rob Bishop\n  party: majority\n  rank: 17\n  bioguide: B001250\n  thomas: '01753'\n  title: Ex Officio\n- name: Alan S. Lowenthal\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: L000579\n  thomas: '02111'\n- name: Jim Costa\n  party: minority\n  rank: 2\n  bioguide: C001059\n  thomas: '01774'\n- name: Niki Tsongas\n  party: minority\n  rank: 3\n  bioguide: T000465\n  thomas: '01884'\n- name: Donald S. Beyer Jr.\n  party: minority\n  rank: 4\n  bioguide: B001292\n  thomas: '02272'\n- name: Ruben Gallego\n  party: minority\n  rank: 5\n  bioguide: G000574\n  thomas: '02226'\n- name: Jared Polis\n  party: minority\n  rank: 7\n  bioguide: P000598\n  thomas: '01910'\n- name: Raúl M. Grijalva\n  party: minority\n  rank: 15\n  bioguide: G000551\n  thomas: '01708'\n  title: Ex Officio\nHSII10:\n- name: Tom McClintock\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: M001177\n  thomas: '01908'\n- name: Don Young\n  party: majority\n  rank: 2\n  bioguide: Y000033\n  thomas: '01256'\n- name: Louie Gohmert\n  party: majority\n  rank: 3\n  bioguide: G000552\n  thomas: '01801'\n- name: Glenn Thompson\n  party: majority\n  rank: 4\n  bioguide: T000467\n  thomas: '01952'\n- name: Raúl R. Labrador\n  party: majority\n  rank: 6\n  bioguide: L000573\n  thomas: '02011'\n- name: Doug LaMalfa\n  party: majority\n  rank: 7\n  bioguide: L000578\n  thomas: '02100'\n- name: Bruce Westerman\n  party: majority\n  rank: 8\n  bioguide: W000821\n  thomas: '02224'\n- name: Dan Newhouse\n  party: majority\n  rank: 9\n  bioguide: N000189\n  thomas: '02275'\n- name: Ryan K. Zinke\n  party: majority\n  rank: 10\n  bioguide: Z000018\n  thomas: '02254'\n- name: Jody B. Hice\n  party: majority\n  rank: 11\n  bioguide: H001071\n  thomas: '02237'\n- name: Thomas MacArthur\n  party: majority\n  rank: 12\n  bioguide: M001193\n  thomas: '02258'\n- name: Darin LaHood\n  party: majority\n  rank: 14\n  bioguide: L000585\n  thomas: '02295'\n- name: Rob Bishop\n  party: majority\n  rank: 15\n  bioguide: B001250\n  thomas: '01753'\n  title: Ex Officio\n- name: Niki Tsongas\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: T000465\n  thomas: '01884'\n- name: Donald S. Beyer Jr.\n  party: minority\n  rank: 2\n  bioguide: B001292\n  thomas: '02272'\n- name: Jared Huffman\n  party: minority\n  rank: 4\n  bioguide: H001068\n  thomas: '02101'\n- name: Alan S. Lowenthal\n  party: minority\n  rank: 5\n  bioguide: L000579\n  thomas: '02111'\n- name: Debbie Dingell\n  party: minority\n  rank: 6\n  bioguide: D000624\n  thomas: '02251'\n- name: Jared Polis\n  party: minority\n  rank: 8\n  bioguide: P000598\n  thomas: '01910'\n- name: Raúl M. Grijalva\n  party: minority\n  rank: 13\n  bioguide: G000551\n  thomas: '01708'\n  title: Ex Officio\nHSII13:\n- name: Don Young\n  party: majority\n  rank: 2\n  bioguide: Y000033\n  thomas: '01256'\n- name: Robert J. Wittman\n  party: majority\n  rank: 3\n  bioguide: W000804\n  thomas: '01886'\n- name: Tom McClintock\n  party: majority\n  rank: 4\n  bioguide: M001177\n  thomas: '01908'\n- name: Jeff Duncan\n  party: majority\n  rank: 6\n  bioguide: D000615\n  thomas: '02057'\n- name: Paul A. Gosar\n  party: majority\n  rank: 7\n  bioguide: G000565\n  thomas: '01992'\n- name: Doug LaMalfa\n  party: majority\n  rank: 8\n  bioguide: L000578\n  thomas: '02100'\n- name: Jeff Denham\n  party: majority\n  rank: 9\n  bioguide: D000612\n  thomas: '01995'\n- name: Garret Graves\n  party: majority\n  rank: 10\n  bioguide: G000577\n  thomas: '02245'\n- name: Dan Newhouse\n  party: majority\n  rank: 11\n  bioguide: N000189\n  thomas: '02275'\n- name: Thomas MacArthur\n  party: majority\n  rank: 12\n  bioguide: M001193\n  thomas: '02258'\n- name: Rob Bishop\n  party: majority\n  rank: 13\n  bioguide: B001250\n  thomas: '01753'\n  title: Ex Officio\n- name: Jared Huffman\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: H001068\n  thomas: '02101'\n- name: Grace F. Napolitano\n  party: minority\n  rank: 2\n  bioguide: N000179\n  thomas: '01602'\n- name: Jim Costa\n  party: minority\n  rank: 3\n  bioguide: C001059\n  thomas: '01774'\n- name: Ruben Gallego\n  party: minority\n  rank: 4\n  bioguide: G000574\n  thomas: '02226'\n- name: Madeleine Z. Bordallo\n  party: minority\n  rank: 5\n  bioguide: B001245\n  thomas: '01723'\n- name: Gregorio Kilili Camacho Sablan\n  party: minority\n  rank: 6\n  bioguide: S001177\n  thomas: '01962'\n- name: Raul Ruiz\n  party: minority\n  rank: 7\n  bioguide: R000599\n  thomas: '02109'\n- name: Alan S. Lowenthal\n  party: minority\n  rank: 8\n  bioguide: L000579\n  thomas: '02111'\n- name: Norma J. Torres\n  party: minority\n  rank: 9\n  bioguide: T000474\n  thomas: '02231'\n- name: Debbie Dingell\n  party: minority\n  rank: 10\n  bioguide: D000624\n  thomas: '02251'\n- name: Raúl M. Grijalva\n  party: minority\n  rank: 11\n  bioguide: G000551\n  thomas: '01708'\n  title: Ex Officio\nHSII15:\n- name: Louie Gohmert\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: G000552\n  thomas: '01801'\n- name: Doug Lamborn\n  party: majority\n  rank: 2\n  bioguide: L000564\n  thomas: '01834'\n- name: Raúl R. Labrador\n  party: majority\n  rank: 3\n  bioguide: L000573\n  thomas: '02011'\n- name: Bruce Westerman\n  party: majority\n  rank: 4\n  bioguide: W000821\n  thomas: '02224'\n- name: Jody B. Hice\n  party: majority\n  rank: 5\n  bioguide: H001071\n  thomas: '02237'\n- name: Aumua Amata Coleman Radewagen\n  party: majority\n  rank: 6\n  bioguide: R000600\n  thomas: '02222'\n- name: Alexander X. Mooney\n  party: majority\n  rank: 7\n  bioguide: M001195\n  thomas: '02277'\n- name: Darin LaHood\n  party: majority\n  rank: 8\n  bioguide: L000585\n  thomas: '02295'\n- name: Rob Bishop\n  party: majority\n  rank: 9\n  bioguide: B001250\n  thomas: '01753'\n  title: Ex Officio\n- name: Debbie Dingell\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: D000624\n  thomas: '02251'\n- name: Jared Huffman\n  party: minority\n  rank: 2\n  bioguide: H001068\n  thomas: '02101'\n- name: Ruben Gallego\n  party: minority\n  rank: 3\n  bioguide: G000574\n  thomas: '02226'\n- name: Jared Polis\n  party: minority\n  rank: 4\n  bioguide: P000598\n  thomas: '01910'\n- name: Wm. Lacy Clay\n  party: minority\n  rank: 5\n  bioguide: C001049\n  thomas: '01654'\n- name: Raúl M. Grijalva\n  party: minority\n  rank: 7\n  bioguide: G000551\n  thomas: '01708'\n  title: Ex Officio\nHSII24:\n- name: Don Young\n  party: majority\n  rank: 1\n  title: Chair\n  bioguide: Y000033\n  thomas: '01256'\n- name: Paul A. Gosar\n  party: majority\n  rank: 3\n  bioguide: G000565\n  thomas: '01992'\n- name: Doug LaMalfa\n  party: majority\n  rank: 4\n  bioguide: L000578\n  thomas: '02100'\n- name: Jeff Denham\n  party: majority\n  rank: 5\n  bioguide: D000612\n  thomas: '01995'\n- name: Paul Cook\n  party: majority\n  rank: 6\n  bioguide: C001094\n  thomas: '02103'\n- name: Aumua Amata Coleman Radewagen\n  party: majority\n  rank: 7\n  bioguide: R000600\n  thomas: '02222'\n- name: Rob Bishop\n  party: majority\n  rank: 8\n  bioguide: B001250\n  thomas: '01753'\n  title: Ex Officio\n- name: Raul Ruiz\n  party: minority\n  rank: 1\n  title: Ranking Member\n  bioguide: R000599\n  thomas: '02109'\n- name: Madeleine Z. Bordallo\n  party: minority\n  rank: 2\n  bioguide: B001245\n  thomas: '01723'\n- name: Gregorio Kilili Camacho Sablan\n  party: minority\n  rank: 3\n  bioguide: S001177\n  thomas: '01962'\n- name: Norma J. Torres\n  party: minority\n  rank: 5\n  bioguide: T000474\n  thomas: '02231'\n- name: Raúl M. Grijalva\n  party: minority\n  rank: 6\n  bioguide: G000551\n  thomas: '01708'\n  title: Ex Officio\n",
      "\"ca24889fcd989a1956cd67e267bf4df4\""
    }
  end

  # - id:
  #   bioguide: O000167
  #   thomas: '01763'
  #   lis: S298
  #   govtrack: 400629
  #   opensecrets: N00009638
  #   votesmart: 9490
  #   name:
  #   first: Barack
  #   middle: Hussein
  #   last: Obama
  #   bio:
  #   birthday: '1961-08-04'
  #   gender: M
  #   terms:
  #   - type: prez
  #   start: '2009-01-20'
  #   end: '2013-01-20'
  #   party: Democrat
  #   how: election
  #   - type: prez
  #   start: '2013-01-20'
  #   end: '2017-01-20'
  #   party: Democrat
  #   how: election
  def fetch_file("executive.yaml") do
    {
      "- id:\n    govtrack: 412344\n    icpsr_prez: 99880\n  name:\n    first: Zachary\n    last: Taylor\n  bio:\n    birthday: '1784-11-24'\n    gender: M\n  terms:\n  - type: prez\n    start: '1849-03-04'\n    end: '1850-07-09'\n    party: Whig\n    how: election\n" <>
      "- id:\n    bioguide: O000167\n    thomas: '01763'\n    lis: S298\n    govtrack: 400629\n    opensecrets: N00009638\n    votesmart: 9490\n  name:\n    first: Barack\n    middle: Hussein\n    last: Obama\n  bio:\n    birthday: '1961-08-04'\n    gender: M\n  terms:\n  - type: prez\n    start: '2009-01-20'\n    end: '2013-01-20'\n    party: Democrat\n    how: election\n  - type: prez\n    start: '2013-01-20'\n    end: '2017-01-20'\n    party: Democrat\n    how: election\n" <>
      "- id:\n    bioguide: P000587\n    thomas: '01649'\n    govtrack: 400315\n    opensecrets: N00003765\n    votesmart: 34024\n    fec:\n    - H8IN02060\n    wikipedia: Mike Pence\n    house_history: 20013\n    icpsr: 20117\n    wikidata: Q24313\n    google_entity_id: kg:/m/022r9r\n  name:\n    first: Mike\n    last: Pence\n  bio:\n    birthday: '1959-06-07'\n    gender: M\n  terms:\n  - type: viceprez\n    start: '2017-01-20'\n    end: '2021-01-20'\n    party: Republican\n    how: election\n" <>
      "- id:\n    govtrack: 412733\n    opensecrets: N00023864\n    votesmart: 15723\n    fec:\n    - P80001571\n    wikipedia: Donald Trump\n  name:\n    first: Donald\n    middle: J.\n    last: Trump\n  bio:\n    birthday: '1946-06-14'\n    gender: M\n  terms:\n  - type: prez\n    start: '2017-01-20'\n    end: '2021-01-20'\n    party: Republican\n    how: election\n",
      "\"c82fc61a0e6f5a0baa56930d7cf7749a\""
    }
  end

  def parse_file(file_as_string), do: KratosApi.RemoteStorage.parse_file(file_as_string)

end

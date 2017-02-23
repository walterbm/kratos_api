defmodule KratosApi.RemoteService.InMemory do

  def fetch_bio("Sherrod Brown"), do: "Sherrod Campbell Brown (born November 9, 1952) is the senior United States Senator from Ohio, in office since January 3, 2007. Brown is a member of the Democratic Party. Before his election to the Senate, he was a member of the United States House of Representatives, representing Ohio's 13th congressional district from 1993 to 2007. He previously served as the Ohio Secretary of State (1983–1991) and as a member of the Ohio House of Representatives (1974–1982).\nBrown defeated two-term Republican incumbent Mike DeWine in the 2006 Senate election and was re-elected in 2012, defeating state Treasurer Josh Mandel."

  def fetch_bio("Dennis A. Ross"), do: "Dennis Alan Ross (born October 18, 1959) is an American politician who has been a member of the United States House of Representatives since 2011. A Republican from Florida, his district was numbered as Florida's 12th congressional district during his first two years in Congress; it has been the 15th district since 2013."

  def fetch_bio("Rob Bishop"), do: "Robert William \"Rob\" Bishop (born July 13, 1951) is the U.S. Representative for Utah's 1st congressional district, serving since 2003. He is a member of the Republican Party."

  def fetch_bio("Roy Blunt"), do: "Roy Dean Blunt (born January 10, 1950) is an American politician who currently serves as the junior United States Senator from Missouri, having been in office since 2011. He is a member of the Republican Party.\nBlunt served as the United States Representative from Missouri's 7th congressional district from 1997 to 2011. The district contains most of Southwest Missouri, anchored in the city of Springfield, as well as the cities of Joplin, Carthage, and Neosho, and the popular tourist destination of Branson.\nBlunt served as House Majority Whip from 2003 to 2007, and was acting House Majority Leader from September 2005 to February 2006."

  def fetch_bio(_), do: "No Bio Found"
end

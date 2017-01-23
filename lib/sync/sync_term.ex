defmodule  KratosApi.Sync.Term do

  alias KratosApi.{
    SyncHelpers
  }

  @term_types %{"sen" => "Senate", "rep" => "House"}

  def prepare(data) do
    %{
      type: @term_types[data['type'] |> to_string],
      start: SyncHelpers.convert_date(data['start']),
      end: SyncHelpers.convert_date(data['end']),
      state: data['state'] |> to_string,
      district: data['district'] |> to_string,
      class: data['class'] |> to_string,
      state_rank: data['state_rank'] |> to_string,
      party: data['party'] |> to_string,
      caucus: data['caucus'] |> to_string,
      party_affiliations: data['party_affiliations'] |> SyncHelpers.flat_map_to_string,
      url: data['url'] |> to_string,
      address: data['address'] |> to_string,
      phone: data['phone'] |> to_string,
      fax: data['fax'] |> to_string,
      contact_form: data['contact_form'] |> to_string,
      office: data['office'] |> to_string,
      rss_url: data['rss_url'] |> to_string,
    }
  end
end

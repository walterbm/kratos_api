defmodule KratosApi.SyncHelpers do

  alias KratosApi.{
    Repo,
    FileHash,
  }

  @remote_storage Application.get_env(:kratos_api, :remote_storage)

  def apply_assoc(changeset, _, nil), do: changeset
  def apply_assoc(changeset, field, data), do: Ecto.Changeset.put_assoc(changeset, field, data)

  def convert_date(date_as_string), do: convert_date_or_datetime(date_as_string, Date)
  def convert_date(date_as_string, format_string), do: convert_date_or_datetime_with_timex(date_as_string, format_string) |> DateTime.to_date

  def convert_datetime(date_as_string), do: convert_date_or_datetime(date_as_string, NaiveDateTime)
  def convert_datetime(date_as_string, format_string), do: convert_date_or_datetime_with_timex(date_as_string, format_string)

  defp convert_date_or_datetime(date, date_module) when is_list(date) do
    convert_date_or_datetime(to_string(date), date_module)
  end
  defp convert_date_or_datetime(date_as_string, date_module) do
    unless is_nil(date_as_string) do
      case date_module.from_iso8601(date_as_string) do
        {:ok, date} -> date
        {:error, _} -> nil
      end
    end
  end

  defp convert_date_or_datetime_with_timex(date_as_string, format_string) do
    date_as_string
    |> Timex.parse!("{#{format_string}}")
    |> Timex.Timezone.convert("UTC")
  end

  def convert_to_map([head | tail]) when is_list(head) do
    Enum.map([head | tail], &(convert_to_map(&1)))
  end
  def convert_to_map([head | tail]) when is_tuple(head) do
    Enum.into([head | tail], %{}) |> convert_to_map
  end
  def convert_to_map(x) when is_map(x) do
    Enum.reduce(x, %{}, fn({k, v}, acc) ->
      Map.merge(acc, %{k => convert_to_map(v)})
    end)
  end
  def convert_to_map({key, value}) do
    %{key => value} |> convert_to_map
  end
  def convert_to_map(x), do: x

  def flat_map_to_string(data) when is_list(data) do
    Enum.map(data, &flat_map_to_string/1)
  end
  def flat_map_to_string(data) when is_map(data) do
    Enum.reduce(data, %{}, fn({k, v}, acc) ->
      Map.merge(acc, %{to_string(k) => to_string(v)})
    end)
  end
  def flat_map_to_string(nil), do: nil

  def sync_from_storage(file_name, save_fx) do
    {document, hash} = @remote_storage.fetch_file(file_name)
    run_sync_from_storage(save_fx, document, FileHash.exists?(hash, file_name))
  end

  defp run_sync_from_storage(save_fx, document, {:ok, :new}) do
    document
      |> @remote_storage.parse_file
      |> Enum.map(&convert_to_map/1)
      |> Enum.map(&(save_fx.(&1)))
  end

  defp run_sync_from_storage(_save_fx, _document, _exists), do: false

  def save(changeset, kargs, update_fx) do
    case Repo.get_by(changeset.data.__struct__, kargs) do
      nil  ->
        Repo.insert!(changeset)
      record ->
        record
        |> update_fx.(changeset)
        |> Repo.update!
    end
  end

  def save(changeset, kargs) do
    record = Repo.get_by(changeset.data.__struct__, kargs)
    if record do
      record
    else
      Repo.insert!(changeset)
    end
  end

  def gen_md5(value) do
    :crypto.hash(:sha256, value) |> Base.encode64
  end
end

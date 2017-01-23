defmodule KratosApi.SyncHelpers do

  def apply_assoc(changeset, _, nil), do: changeset
  def apply_assoc(changeset, field, data), do: Ecto.Changeset.put_assoc(changeset, field, data)

  def convert_date(date_as_string), do: convert_date_or_datetime(date_as_string, Date)

  def convert_datetime(date_as_string), do: convert_date_or_datetime(date_as_string, NaiveDateTime)

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

  def save(changeset, kargs) do
    result =
      case KratosApi.Repo.get_by(changeset.data.__struct__, kargs) do
        nil  ->
          KratosApi.Repo.insert(changeset)
        record ->
          changes = changeset.data.__struct__.changeset(record, changeset.changes)
          KratosApi.Repo.update(changes)
      end

    case result do
      {:ok, record}       -> record
      {:error, changeset} -> changeset.errors
    end
  end
end

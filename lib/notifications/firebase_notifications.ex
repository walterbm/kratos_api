defmodule KratosApi.Notifications.Push do

  alias KratosApi.Notifications.Message

  @fcm_config Application.get_env(:kratos_api, :cloud_messaging, %{})

  def notify(%Message{ body: body, title: title }, push_token) do
    build_notification_request(title, body, push_token)
    |> send
    |> check
  end

  defp build_notification_request(message, title, push_token) do
    Poison.encode!(%{
      notification: %{
        title: title,
        body: message
      },
      to: push_token
    })
  end

  defp send(body) do
    HTTPotion.post(
      fcm_url(),
      [
        body: body,
        headers: [
          "Content-Type": "application/json",
          "Authorization": "key=#{server_key()}",
        ]
      ]
    )
  end

  defp check(%HTTPotion.Response{body: body, status_code: 200}) do
    response = Poison.decode!(body)

    case response do
      %{ "failure" => 1, "results" => results } -> {:error, results}
      %{ "success" => 1, "results" => results } -> {:ok, results}
    end
  end
  defp check(%HTTPotion.Response{body: body, status_code: _code}) do
    {:error, Poison.decode!(body)}
  end

  defp fcm_url(), do: Map.get(@fcm_config, :url)

  defp server_key(), do: Map.get(@fcm_config, :server_key)

end

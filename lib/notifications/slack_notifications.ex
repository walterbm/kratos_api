defmodule KratosApi.Notifications.Slack do

  @slack_url Application.get_env(:kratos_api, :slack_url, "")

  def notify(message) do
    HTTPotion.get(@slack_url <> "&text=" <> URI.encode(message))
  end

end

defmodule KratosApi.RemoteQueue do

  def fetch_queue(name), do: build_queue(name)

  defp build_queue(name, queue \\ [], num_empty_responses \\ 0)
  defp build_queue(name, queue, num_empty_responses) when num_empty_responses < 5 do
    {:ok, response} = ExAws.SQS.receive_message(name) |> ExAws.request
    cond do
      Enum.empty?(response.body.messages) -> build_queue(name, queue, num_empty_responses + 1)
      true -> build_queue(name, queue ++ response.body.messages, num_empty_responses)
    end
  end
  defp build_queue(_name, queue, _num_empty_responses), do: queue

end

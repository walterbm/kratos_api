defmodule KratosApi.RemoteQueue do

  def dequeue(name, _index) do
    {:ok, response} = ExAws.SQS.receive_message(name) |> ExAws.request
    response.body.messages
  end

end

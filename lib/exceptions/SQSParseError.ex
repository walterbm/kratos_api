defmodule SQSParseError do
  defexception message: "The incoming JSON data from the SQS queue could not be parsed"
end

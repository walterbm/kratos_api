# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kratos_api,
  ecto_repos: [KratosApi.Repo]

# Configures the endpoint
config :kratos_api, KratosApi.Endpoint,
  instrumenters: [Appsignal.Phoenix.Instrumenter],
  url: [host: "localhost"],
  secret_key_base: "6IYOy+XYU0wgMKMYSUQAIaucMkMoJ3EL+YelFu1R61g3izX35HRRBT80dlPj5lzv",
  render_errors: [view: KratosApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KratosApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Elastix for ElasticSearch
config :elastix,
  custom_headers: {Kratos.Search.Auth, :add_aws_signature, []}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

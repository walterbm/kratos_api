use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :kratos_api, KratosApi.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Watch static and templates for browser reloading.
config :kratos_api, KratosApi.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Environment Dependencies
config :kratos_api, :govtrack_api, Govtrack
config :kratos_api, :remote_queue, KratosApi.RemoteQueue
config :kratos_api, :remote_storage, KratosApi.RemoteStorage
config :kratos_api, :remote_service, KratosApi.RemoteService
config :kratos_api, :remote_scraper, KratosApi.RemoteScrape
config :kratos_api, :token_gen, KratosApi.TokenGen
config :kratos_api, :slack, KratosApi.Slack
config :kratos_api, :url, "http://localhost:4000"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

import_config "dev.secret.exs"

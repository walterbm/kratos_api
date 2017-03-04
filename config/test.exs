use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kratos_api, KratosApi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :kratos_api, KratosApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "kratos_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  timeout: :infinity,
  pool_timeout: :infinity

# Environment Dependencies
config :kratos_api, :govtrack_api, KratosApi.Govtrack.InMemory
config :kratos_api, :remote_queue, KratosApi.RemoteQueue.InMemory
config :kratos_api, :remote_storage, KratosApi.RemoteStorage.InMemory
config :kratos_api, :remote_service, KratosApi.RemoteService.InMemory
config :kratos_api, :remote_scraper, KratosApi.RemoteScrape.InMemory
config :kratos_api, :token_gen, KratosApi.TokenGen.InMemory
config :kratos_api, :slack, KratosApi.Slack.InMemory
config :kratos_api, :url, "https://lol.com"

# Authentication
config :guardian, Guardian,
  issuer: "KratosApiTest",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "testing123",
  serializer: KratosApi.GuardianSerializer

# Assets
config :kratos_api, :assets_url, "https://supersecretdatabase.com"

# Joken
config :joken,
  secret_key: "super-secret"

# Email
config :kratos_api, KratosApi.Mailer,
  adapter: Bamboo.TestAdapter

# Slack
config :kratos_api, :slack_url, "slack.slack"

defmodule KratosApi.Mixfile do
  use Mix.Project

  def project do
    [app: :kratos_api,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {KratosApi, []},
     applications: [
        :appsignal,
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :cowboy,
        :logger,
        :gettext,
        :phoenix_ecto,
        :postgrex,
        :gen_stage,
        :flow,
        :httpotion,
        :govtrack,
        :guardian,
        :comeonin,
        :joken,
        :bamboo,
        :bamboo_smtp,
        :kerosene,
        :sweet_xml,
        :yamerl,
        :exrm,
        :edeliver,
        :ex_aws
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gen_stage, "~> 0.11"},
      {:flow, "~> 0.11"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:govtrack, "~> 0.7.3"},
      {:httpotion, "~> 3.0.0"},
      {:guardian, "~> 0.12.0"},
      {:comeonin, "~> 2.5"},
      {:joken, "~> 1.4"},
      {:bamboo, "~> 0.8.0"},
      {:bamboo_smtp, "~> 1.3.0"},
      {:ex_aws, "~> 1.1.0"},
      {:sweet_xml, "~> 0.6.2"},
      {:yamerl, "~> 0.4.0"},
      {:kerosene, "~> 0.5.0"},
      {:exrm, "~> 1.0.8"},
      {:edeliver, "~> 1.3.0"},
      {:appsignal, "~> 0.0"},
      {:credo, "~> 0.5", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

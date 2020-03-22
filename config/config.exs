# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :noveo,
  ecto_repos: [Noveo.Repo]

# Configures the endpoint
config :noveo, NoveoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OpR16Dwj0q7xzuaFc32bFQ1ZWod1Z6jAfIRIzfNnqLkGO0exu9QM/T7EZoxMrI/M",
  render_errors: [view: NoveoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Noveo.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ryN9cpwn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :geocoder, :worker_pool_config, size: 4, max_overflow: 2
config :geocoder, :worker,
  # OpenStreetMaps or OpenCageData are other supported providers
  provider: Geocoder.Providers.OpenCageData,
  key: System.get_env("OPEN_CAGE_API_KEY")

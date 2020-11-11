# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :underscorecore,
  ecto_repos: [Underscorecore.Repo]

# Configures the endpoint
config :underscorecore, UnderscorecoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GuxJxjWvK/W5lF+z3i2lHa2+kR8R3v96Pkgf2z0CwbZd+61iqPo9C2KB5waR8Xf6",
  render_errors: [view: UnderscorecoreWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Underscorecore.PubSub,
  live_view: [signing_salt: "PajiI7zP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

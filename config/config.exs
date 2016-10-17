# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :stockman,
  ecto_repos: [Stockman.Repo]

# Configures the endpoint
config :stockman, Stockman.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rrd+/tX2aQcMcujnfoYU9236A6E9/LExGEtyOdy/0YghYv1QycoQCAbK8bmXgQ7T",
  render_errors: [view: Stockman.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Stockman.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Stockman",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: "123secretkeybleatj",
  serializer: Stockman.GuardianSerializer

# Pagination
config :scrivener_html,
  routes_helper: Stockman.Router.Helpers

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

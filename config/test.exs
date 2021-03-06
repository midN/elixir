use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stockman, Stockman.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :stockman, Stockman.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "stockman_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :stockman, :fixer_api, Stockman.FixerMock
config :stockman, :queue, Stockman.ExqMock

config :exq_ui, server: false

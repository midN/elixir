use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :stockman, Stockman.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :stockman, Stockman.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :stockman, Stockman.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "stockman",
  password: "stockman",
  database: "stockman_dev",
  hostname: "localhost",
  pool_size: 10

config :exq,
  host: "127.0.0.1",
  port: 6379,
  namespace: "exq",
  concurrency: 10,
  queues: ["default"],
  max_retries: 5

config :stockman, :fixer_api, Stockman.Fixer
config :stockman, :queue, Exq

import_config "dev.secret.exs"

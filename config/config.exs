# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :converter, ConverterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yEZh8lW9VxyayJ09TWxbvT3gPKw1V+2pI6exVnPAY3Cv3UEGt6LkeSLXQPakWKAG",
  render_errors: [view: ConverterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Converter.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

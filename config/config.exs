# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :idk_pay,
  ecto_repos: [IdkPay.Repo]

# Configures the endpoint
config :idk_pay, IdkPayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "U6rb9AJCDoSe1LtiNJOsLGzUW8+S60TApNALK1lnjems+w+yx3pcMD2d4dskTxax",
  render_errors: [view: IdkPayWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: IdkPay.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Guardian
config :idk_pay, IdkPay.Auth.Guardian,
  issuer: "idk_pay",
  secret_key: "HNinpKh9Ne3tr8BpjCpAEh0xzCqTIG3PWsfkR2AtzvUaRIpbs6oIQ9RcmjmGPekJ"

config :idk_pay, IdkPay.Auth.AuthAccessPipeline,
  module: IdkPay.Auth.Guardian,
  error_handler: IdkPay.Auth.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

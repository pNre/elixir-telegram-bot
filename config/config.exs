# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :rebot, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:rebot, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
config :nadia,
  token: System.get_env("TELEGRAM_BOT_TOKEN")

config :rebot,
  imgur_token: System.get_env("IMGUR_TOKEN")

config :rebot,
  wit_token: System.get_env("WIT_BOT_TOKEN"),
  wit_version: "20161208"

config :rebot,
  apiai_token: System.get_env("APIAI_BOT_TOKEN"),
  apiai_version: "20161210"

config :rebot,
  giphy_key: "dc6zaTOxFJmzC"

config :rebot,
  webhook_url: System.get_env("WEBHOOK_URL"),
  certfile: Path.expand("ssl/cert.pem", __DIR__),
  keyfile: Path.expand("ssl/key.pem", __DIR__)

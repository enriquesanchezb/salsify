use Mix.Config

# Get slack token from system env
config :salsify, Salsify,
       token: System.get_env("SLACK_TOKEN")

config :salsify, Salsify.Repo,
       adapter: Sqlite.Ecto2,
       database: "salsify.sqlite3"

config :salsify,
       ecto_repos: [Salsify.Repo]

import_config "#{Mix.env}.exs"
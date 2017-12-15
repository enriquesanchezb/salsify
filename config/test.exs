use Mix.Config

config :salsify, enable_salsify_worker: false

config :salsify, Salsify.Repo,
       adapter: Sqlite.Ecto2,
       database: "salsify_test.sqlite3",
       size: 1,
       max_overflow: 0,
       pool: Ecto.Adapters.SQL.Sandbox

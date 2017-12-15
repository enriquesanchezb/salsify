defmodule Salsify.Repo do
  use Ecto.Repo, otp_app: :salsify, adapter: Sqlite.Ecto2
end

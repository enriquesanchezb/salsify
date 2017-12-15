defmodule Salsify.Repo.Migrations.Lovers do
  use Ecto.Migration

  def change do
    create table(:lovers) do
      add :lover_one, :string
      add :lover_two, :string
      add :love, :string

      timestamps()
    end
  end
end

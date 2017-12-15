defmodule Salsify.Lovers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lovers" do
    field :lover_one, :string
    field :lover_two, :string
    field :love, :string
    timestamps()
  end

  def changeset(lovers, params \\ %{}) do
    lovers
    |> cast(params, ~w(lover_one lover_two love))
    |> validate_required([:lover_one, :lover_two, :love])
  end
end

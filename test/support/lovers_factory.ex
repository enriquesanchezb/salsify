defmodule Salsify.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Salsify.Repo

  def lovers_factory do
    %Salsify.Lovers{
      lover_one: "U1",
      lover_two: "U2",
      love: "U1"
    }
  end
end

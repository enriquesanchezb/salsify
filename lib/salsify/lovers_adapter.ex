defmodule Salsify.LoversAdapter do
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Salsify.{Repo, Lovers}

  def valid_love?(lover, loved, bot) do
    cond do
      lover == bot ->
        {:invalid, "Algo raro está pasando... Creo que he tomado conciencia!"}
      lover == loved ->
        {:invalid, "Ya sabemos que te quieres a ti mismo"}
      loved == bot ->
        {:invalid, "Sé que me amas pero sólo soy una máquina :robot_face:"}
      true ->
        {:valid, nil}
    end
  end

  def search_love(lover, loved) do
    [user1, user2] = sort_lovers(lover, loved)
    query = from l in Lovers,
                 where: l.lover_one == ^user1 and l.lover_two == ^user2,
                 select: l.love
    case Repo.all(query) do
      [] ->
        {:not_created, nil}
      [user] ->
        if user == lover or user == loved do
          {:created, user}
        else
          {:invalid, "Algo fue raro"}
        end
      [_, "MATCH"] ->
        {:match, "Ya teníais match. No quieras abusar"}
      _ ->
        {:invalid, "Algo fue raro"}
    end
  end

  def create_relationship(lover, loved) do
    [user1, user2] = sort_lovers(lover, loved)
    lovers = %Lovers{lover_one: user1, lover_two: user2, love: lover}
    Repo.insert!(lovers)
  end

  def update_relationship(lover, loved) do
    [user1, user2] = sort_lovers(lover, loved)
    %Lovers{lover_one: user1, lover_two: user2, love: "MATCH"}
    |> change
    |> Repo.insert!
  end

  defp sort_lovers(lover, loved) do
    [lover, loved]
    |> Enum.sort
  end
end

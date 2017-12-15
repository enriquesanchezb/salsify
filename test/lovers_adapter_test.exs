defmodule Salsify.LoversAdapterTest do
  use ExUnit.Case, async: true
  use Salsify.TestHelper
  alias Salsify.LoversAdapter, as: LoversAdapter

  import Salsify.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Salsify.Repo)
  end

  test "Valid love" do
    assert LoversAdapter.valid_love?(@user1, @user2, @bot) ==  {:valid, nil}
    assert LoversAdapter.valid_love?(@user1, @user1, @bot) ==  {:invalid, "Ya sabemos que te quieres a ti mismo"}
    assert LoversAdapter.valid_love?(@user1, @bot, @bot) ==  {:invalid, "Sé que me amas pero sólo soy una máquina :robot_face:"}
    assert LoversAdapter.valid_love?(@bot, @user2, @bot) ==  {:invalid, "Algo raro está pasando... Creo que he tomado conciencia!"}
  end

  test "Search love when there is not any relationship yet " do
    build(:lovers)
    assert LoversAdapter.search_love(@user1, @user2) == {:not_created, nil}
  end

  test "Search love when there is a relationship but is not a match" do
    build(:lovers)
    LoversAdapter.create_relationship(@user1, @user2)
    assert LoversAdapter.search_love(@user1, @user2) == {:created, @user1}
  end

  test "Search love when there is a relationship and a match" do
    build(:lovers)
    LoversAdapter.create_relationship(@user1, @user2)
    LoversAdapter.update_relationship(@user2, @user1)
    assert LoversAdapter.search_love(@user1, @user2) == {:match, "Ya teníais match. No quieras abusar"}
  end

  test "What happens if the relationship row is corrupted" do
    build(:lovers)
    insert(:lovers, %{lover_one: @user1, lover_two: @user2, love: "XXX"})
    assert LoversAdapter.search_love(@user1, @user2) == {:invalid, "Algo fue raro"}
  end
end
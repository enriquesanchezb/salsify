ExUnit.start()

defmodule Salsify.TestHelper do
  defmacro __using__(_) do
    quote do
      @user1 "user1"
      @user2 "user2"
      @bot "bot"

      {:ok, _} = Application.ensure_all_started(:ex_machina)
    end
  end
end
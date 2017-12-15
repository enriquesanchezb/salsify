defmodule Salsify.Parser do
  def parse(message) do
    case extract_user(message) do
      "" -> nil
      user -> {:ok, user}
    end
  end

  defp extract_user(message) do
    try do
      Regex.split(~r/(me gusta|ME GUSTA)/, message)
      |> Enum.at(1)
      |> String.trim
      |> String.slice(2..-2)
    rescue
      FunctionClauseError -> ""
    end
  end
end
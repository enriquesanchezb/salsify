defmodule Salsify.ParserTest do
  use ExUnit.Case, async: true
  use Salsify.TestHelper
  alias Salsify.Parser, as: Parser

  test "me gusta" do
    assert Parser.parse("<@#{@bot}> me gusta <@#{@user1}>") == {:ok, @user1}
    assert Parser.parse("<@#{@bot}>: me gusta <@#{@user1}>") == {:ok, @user1}
    assert Parser.parse("<@#{@bot}>:me gusta <@#{@user1}>") == {:ok, @user1}
    assert Parser.parse("<@#{@bot}> me gusta     <@#{@user1}>") == {:ok, @user1}
    assert Parser.parse("<@#{@bot}>     me gusta     <@#{@user1}>") == {:ok, @user1}
    assert Parser.parse("<@#{@bot}> me gusta <@#{@user1}>   ") == {:ok, @user1}
    assert Parser.parse("<@#{@bot}> ME GUSTA <@#{@user1}>") == {:ok, @user1}
  end

  test "anything else" do
    assert Parser.parse("<@#{@bot}> <@#{@user1}>") == nil
    assert Parser.parse("<@#{@bot}> m e g u s t a <@#{@user1}>") == nil
    assert Parser.parse("<@#{@bot}>: <@#{@user1}>") == nil
    assert Parser.parse("blah blah blah") == nil
  end
end
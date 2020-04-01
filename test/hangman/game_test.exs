defmodule Hangman.GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game/2 returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "make_move/2 do not change game_state if the game is won or lost" do
    game = Game.new_game() |> Map.put(:game_state, :lost)
    {^game, _} = Game.make_move(game, "wtv")
  end

  test "first occurence of letter no already used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter no already used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end
end

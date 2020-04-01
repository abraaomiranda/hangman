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
    ^game = Game.make_move(game, "wtv")
  end

  test "first occurence of letter no already used" do
    game = Game.new_game() |> Game.make_move("x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter no already used" do
    game = Game.new_game() |> Game.make_move("x")
    assert game.game_state != :already_used

    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("xablau") |> Game.make_move("x")
    assert game.game_state == :good_guess
  end

  test "a won is recognized" do
    moves = [
      {"x", :good_guess},
      {"a", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"u", :won}
    ]

    game = Game.new_game("xablau")

    Enum.reduce(moves, game, fn ({guess, state}, new_game) ->
      new_game = Game.make_move(new_game, guess)

      assert new_game.game_state == state
      new_game
    end)
  end

  test "a bad guess is recognized" do
    game = Game.new_game("xablau") |> Game.make_move("e")

    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "a lost is recognized" do
    moves = [
      {"q", :bad_guess, 6},
      {"w", :bad_guess, 5},
      {"e", :bad_guess, 4},
      {"r", :bad_guess, 3},
      {"t", :bad_guess, 2},
      {"y", :bad_guess, 1},
      {"i", :lost, 1},
    ]

    game = Game.new_game("xablau")

    Enum.reduce(moves, game, fn ({guess, state, turns}, new_game) ->
      new_game = Game.make_move(new_game, guess)

      assert new_game.game_state == state
      assert new_game.turns_left == turns
      new_game
    end)
  end
end

defmodule Battleship.Targeting.Proximity.Square do
  def guess(square, board) do
    index = square.index
    cond do
      guess_index = Battleship.Targeting.Proximity.Index.guess(index, index - 1, board) ->
        IO.puts "Guessing left"
        guess_index
      guess_index = Battleship.Targeting.Proximity.Index.guess(index, index + 1, board) ->
        IO.puts "Guessing right"
        guess_index
      guess_index = Battleship.Targeting.Proximity.Index.guess(index, index - Battleship.constants.row_length, board) ->
        IO.puts "Guessing one row above"
        guess_index
      guess_index = Battleship.Targeting.Proximity.Index.guess(index, index + Battleship.constants.row_length, board) ->
        IO.puts "Guessing one row below"
        guess_index
      true ->
        nil
    end
  end
end

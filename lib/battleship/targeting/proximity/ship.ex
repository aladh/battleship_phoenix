defmodule Battleship.Targeting.Proximity.Ship do
  def guess([square | rest], board) do
    guess_index = Battleship.Targeting.Proximity.Square.guess(square, board)
    if guess_index, do: guess_index, else: guess(rest, board)
  end

  def guess([square | rest], board, options) do
    guess_index = Battleship.Targeting.Proximity.Square.guess(square, board, options)
    if guess_index, do: guess_index, else: guess(rest, board, options)
  end
end

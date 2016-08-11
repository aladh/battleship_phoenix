defmodule Battleship.Targeting.Proximity.Ship do
  def guess([square | rest], board) do
    IO.puts "Ship: Single"
    guess_index = Battleship.Targeting.Proximity.Square.guess(square, board)
    if guess_index, do: guess_index, else: guess(rest, board)
  end

  def guess([square | rest], board, options) do
    IO.puts "Ship: multi"
    IO.inspect options
    guess_index = Battleship.Targeting.Proximity.Square.guess(square, board, options)
    if guess_index, do: guess_index, else: guess(rest, board, options)
  end
end

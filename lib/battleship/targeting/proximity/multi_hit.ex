defmodule Battleship.Targeting.Proximity.MultiHit do
  def guess(ship_squares, board) do
    IO.puts "MultiHit"
    Battleship.Targeting.Proximity.Ship.guess(ship_squares, board, direction: direction(ship_squares))
  end

  def direction(squares) do
     if vertical_layout?(squares) do
       :vertical
     else
       :horizontal
     end
  end

  defp vertical_layout?(squares) do
    IO.inspect squares
    index_difference = Enum.at(squares, 0).index - Enum.at(squares, 1).index
    |> abs
    IO.inspect index_difference
    index_difference  == 8
  end
end

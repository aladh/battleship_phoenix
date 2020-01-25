defmodule Battleship.Targeting.Proximity.LayoutDetector do
  def guess(ship_squares, board) do
    Battleship.Targeting.Proximity.Ship.guess(ship_squares, board, direction: direction(ship_squares, board.row_length))
  end

  def direction(squares, row_length) do
     if vertical_layout?(squares, row_length) do
       :vertical
     else
       :horizontal
     end
  end

  defp vertical_layout?(squares, row_length) do
    index_difference = Enum.at(squares, 0).index - Enum.at(squares, 1).index
    |> abs
    index_difference  == row_length
  end
end

defmodule Battleship.Targeting.Hunt.PlacemmentChecker do
  def valid_placement?(_board, 0, _coords, _direction), do: true

  def valid_placement?(board, size, coords, direction) do
    if out_of_bounds?(board, coords) || Battleship.Board.square_revealed?(board, coords) do
      false
    else
      valid_placement?(board, size - 1, next_coords(coords, direction), direction)
    end
  end

  defp next_coords({x, y}, :horizontal), do: {x + 1, y}
  defp next_coords({x, y}, :vertical), do: {x, y + 1}

  defp out_of_bounds?(%{row_length: row_length}, {x, y}) when x > row_length or y > row_length, do: true
  defp out_of_bounds?(_board, _coords), do: false
end

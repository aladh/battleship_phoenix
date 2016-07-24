defmodule Battleship.Board do
  defstruct squares: [], row_length: 8

  def initialize_squares(row_length) do
    squares = for _ <- 0..row_length * row_length - 1, do: %Battleship.Square{}
    %Battleship.Board{squares: squares, row_length: row_length}
  end

  def square_empty?(board, coords) do
    square_at_coords(board, coords)
    |> Battleship.Square.empty?
  end

  defp square_at_coords(board, coords) do
    Enum.at(board.squares, index_at_coords(coords, board.row_length))
  end

  defp index_at_coords({x, y}, row_length) do
    (y - 1) * row_length + x - 1
  end
end

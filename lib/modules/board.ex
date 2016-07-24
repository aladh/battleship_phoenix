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

  def place_ship(board, _ship, []) do
    board
  end

  def place_ship(board, ship, [coord | rest]) do
    new_squares = List.replace_at(board.squares, index_at_coords(coord, board.row_length), %Battleship.Square{ship: ship})
    Map.update!(board, :squares, (fn(_) -> new_squares end))
    |> place_ship(ship, rest)
  end

  def print(board) do
     _print(board, 1)
  end

  defp _print(board = %{squares: squares, row_length: row_length}, row_number) do
    squares
    |> Enum.slice((row_number - 1) * row_length, row_length)
    |> Enum.map(fn(square) -> square.ship end)
    |> IO.inspect(width: 500)

    if row_number < row_length do
      _print(board, row_number + 1)
    end
  end

  defp square_at_coords(board, coords) do
    Enum.at(board.squares, index_at_coords(coords, board.row_length))
  end

  defp index_at_coords({x, y}, row_length) do
    (y - 1) * row_length + x - 1
  end
end

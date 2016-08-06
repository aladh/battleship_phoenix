defmodule Battleship.Board do
  defstruct squares: [], row_length: Battleship.constants[:row_length]

  def new(ships \\ Battleship.constants[:default_ships], row_length \\ Battleship.constants[:row_length]) do
    squares = for index <- 0..row_length * row_length - 1, do: %Battleship.Square{index: index}
    Battleship.ShipPlacer.place(%Battleship.Board{squares: squares, row_length: row_length}, ships)
  end

  def square_empty?(board, coords) do
    square_at_coords(board, coords)
    |> Battleship.Square.empty?
  end

  def square_revealed?(board, coords) do
    square_at_coords(board, coords)
    |> Battleship.Square.revealed?
  end

  def unrevealed_square_indices(%{squares: squares}) do
    _unrevealed_square_indices(squares, 0, [])
  end

  defp _unrevealed_square_indices([square | rest], index, unrevealed_indices) do
    if Battleship.Square.revealed?(square) do
      _unrevealed_square_indices(rest, index + 1, unrevealed_indices)
    else
      _unrevealed_square_indices(rest, index + 1, [index | unrevealed_indices])
    end
  end

  defp _unrevealed_square_indices([], _index, unrevealed_indices) do
    unrevealed_indices
  end

  def place_ship(board, ship, [coord | rest]) do
    index = index_at_coords(coord, board.row_length)
    new_squares = List.replace_at(board.squares, index, %Battleship.Square{ship: ship, status: Battleship.constants[:placed_ship], index: index})
    Map.update!(board, :squares, (fn(_) -> new_squares end))
    |> place_ship(ship, rest)
  end

  def place_ship(board, _ship, []) do
    board
  end

  def index_at_coords({x, y}, row_length \\ Battleship.constants[:row_length]) do
    (y - 1) * row_length + x - 1
  end

  defp square_at_coords(board, coords) do
    Enum.at(board.squares, index_at_coords(coords, board.row_length))
  end
end

defmodule Battleship.BoardGenerator do
  def generate(ships, row_length) do
    _generate(ships, Battleship.Board.initialize_squares(row_length))
  end

  defp _generate([], board) do
    board
  end

  defp _generate([ship | rest], board) do
    coords = ship_coords(ship.size, board)
    new_grid = place_ship(board.squares, coords, board.row_length, ship)
    print_grid(new_grid, board.row_length)
    new_board = Map.update!(board, :squares, (fn(_) -> new_grid end))
    _generate(rest, new_board)
  end

  defp ship_coords(size, board = %{row_length: row_length}) when size <= row_length do
    initial_coord = {:rand.uniform(row_length), :rand.uniform(row_length)}
    direction = :rand.uniform(2)
    if Battleship.Board.square_empty?(board, initial_coord) do
       _ship_coords([initial_coord], direction, board, size)
    else
      IO.puts "Reset"
      ship_coords(size, board)
    end
  end

  defp _ship_coords(coords, direction, board, size) when length(coords) < size do
    next_coord = get_next_coord(List.last(coords), direction)
    if valid_to_place?(next_coord, direction, board) && Battleship.Board.square_empty?(board, next_coord) do
      IO.puts length(coords)
      _ship_coords(Enum.concat(coords, [next_coord]), direction, board, size)
    else
      IO.puts "Reset"
      ship_coords(size, board)
    end
  end

  defp _ship_coords(coords, _direction, _row_length, _size) do
    coords
  end

  defp valid_to_place?({x, _y}, 1, board) do
    x <= board.row_length
  end

  defp valid_to_place?({_x, y}, 2, board) do
    y <= board.row_length
  end

  defp get_next_coord({x, y}, 1) do
    {x + 1, y}
  end

  defp get_next_coord({x, y}, 2) do
    {x, y + 1}
  end

  defp place_ship(grid, ship_coords, row_length, ship) do
    _place_ship(grid, ship_coords, row_length, ship)
  end

  defp _place_ship(grid, [coord | rest], row_length, ship) do
    List.replace_at(grid, index(coord, row_length), %Battleship.Square{ship: ship})
    |> _place_ship(rest, row_length, ship)
  end

  defp _place_ship(grid, [], _row_length, _ship) do
    grid
  end

  defp print_grid(grid, row_length), do: _print_grid(grid, 1, row_length)

  defp _print_grid(grid, row, row_length) do
    grid
    |> Enum.slice((row - 1) * row_length, row_length)
    |> Enum.map(fn(square) -> square.ship end)
    |> IO.inspect(width: 500)

    if row < row_length do
      _print_grid(grid, row + 1, row_length)
    end
  end

  defp index({x, y}, row_length) do
    (y - 1) * row_length + x - 1
  end
end

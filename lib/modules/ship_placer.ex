defmodule Battleship.ShipPlacer do
  def place(board, [ship | rest]) do
    coords = ship_coords(ship.size, board)
    new_board = Battleship.Board.place_ship(board, ship, coords)
    Battleship.Board.print(new_board)
    place(new_board, rest)
  end

  def place(board, []) do
    board
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
    if valid_to_place?(next_coord, direction, board.row_length) && Battleship.Board.square_empty?(board, next_coord) do
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

  defp valid_to_place?({x, _y}, 1, row_length) do
    x <= row_length
  end

  defp valid_to_place?({_x, y}, 2, row_length) do
    y <= row_length
  end

  defp get_next_coord({x, y}, 1) do
    {x + 1, y}
  end

  defp get_next_coord({x, y}, 2) do
    {x, y + 1}
  end
end

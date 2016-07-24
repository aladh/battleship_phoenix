require IEx

defmodule Battleship.BoardGenerator do
  def generate(ships, row_length) do
    _generate(ships, initialize_grid(row_length), row_length)
  end

  defp _generate([], grid, row_length) do
    grid
  end

  defp _generate([ship | rest], grid, row_length) do


    # if empty_squares?(ship_coords, grid, row_length) do
    #   IO.puts "empty"
    # end

    # IEx.pry

    coords = ship_coords(ship.size, row_length)

    new_grid = place_ship(grid, coords, row_length, ship)

    print_grid(new_grid, row_length)

    _generate(rest, new_grid, row_length)
  end

  defp ship_coords(size, row_length) when size <= row_length do
    coords = [{:rand.uniform(row_length), :rand.uniform(row_length)}]
    direction = :rand.uniform(2)
    _ship_coords(coords, direction, row_length, size)
  end

  defp _ship_coords(coords, direction, row_length, size) when length(coords) < size do
    if room_for_next_square?(List.last(coords), direction, row_length) do
      IO.puts length(coords)
      add_square(coords, direction, row_length)
      |> _ship_coords(direction, row_length, size)
    else
      IO.puts "Reset"
      ship_coords(size, row_length)
    end
  end

  defp _ship_coords(coords, _direction, _row_length, _size) do
    coords
  end

  defp room_for_next_square?({x, _y}, 1, row_length) do
    x < row_length
  end

  defp room_for_next_square?({_x, y}, 2, row_length) do
    y < row_length
  end

  defp add_square(coords, 1, row_length) do
    {x, y} = List.last(coords)
    Enum.concat(coords, [{x + 1, y}])
  end

  defp add_square(coords, 2, row_length) do
    {x, y} = List.last(coords)
    Enum.concat(coords, [{x, y + 1}])
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

  defp empty_squares?([coord | rest], grid, row_length) do
    valid =
      grid
      |> Enum.at(index(coord, row_length))
      |> empty_square?
    if valid, do: empty_squares?(rest, grid, row_length), else: false
  end

  defp empty_squares?([], _, _), do: true

  defp empty_square?(%Battleship.Square{ship: nil}), do: true
  defp empty_square?(_), do: false

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

  defp grid_at_coords(grid, coords, row_length) do
    Enum.at(grid, index(coords, row_length), :none)
  end

  defp index({x, y}, row_length) do
    (y - 1) * row_length + x - 1
  end

  defp initialize_grid(row_length) do
    for _ <- 0..row_length * row_length - 1, do: %Battleship.Square{}
  end
end

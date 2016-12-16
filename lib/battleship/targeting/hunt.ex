defmodule Battleship.Targeting.Hunt do
  def guess(board) do
    IO.puts "HUNT"
    IO.inspect healthy_ships(board)

    probabilities =
      initialize_probabilities(board.row_length)
      |> increment_probabilities(healthy_ships(board), board)

    IO.inspect probabilities

    {coords, _value} = Enum.max_by(probabilities, fn {_k, v} -> v end)

    index = Battleship.Board.index_at_coords(coords)

    IO.puts "Guess #{index}"
    index
  end

  defp increment_probabilities(probabilities, [], _board), do: probabilities

  defp increment_probabilities(probabilities, [ship | rest], board) do
    new_probabilities = Map.merge(probabilities, ship_probabilities(board, ship.size), fn(_k, v1, v2) -> v1 + v2 end)
    increment_probabilities(new_probabilities, rest, board)
  end

  defp ship_probabilities(board, size) do
    initial_probabilities = initialize_probabilities(board.row_length)

    Enum.reduce(Map.keys(initial_probabilities), initial_probabilities, fn(coords = {x, y}, probabilities) ->
      horizontal_probabilities =
        if valid_placement?(board, size, coords, :horizontal) do
          Enum.reduce(Enum.to_list(0..size - 1), %{}, fn(distance, p) ->
            Map.update(p, {x + distance, y}, 1, &(&1 + 1))
          end)
        else
          %{}
        end

      vertical_probabilities =
        if valid_placement?(board, size, {x, y}, :vertical) do
          Enum.reduce(Enum.to_list(0..size - 1), %{}, fn(distance, p) ->
            Map.update(p, {x, y + distance}, 1, &(&1 + 1))
          end)
        else
          %{}
        end

      merged_probabilities = Map.merge(vertical_probabilities, horizontal_probabilities, fn(_k, v1, v2) -> v1 + v2 end)
      Map.merge(probabilities, merged_probabilities, fn(_k, v1, v2) -> v1 + v2 end)
    end)
  end

  defp initialize_probabilities(row_length) do
    for y <- 1..row_length, x <- 1..row_length, do: {{x,y}, 0}, into: %{}
  end

  defp valid_placement?(board, size, coords, direction) do
    Battleship.Targeting.Hunt.PlacemmentChecker.valid_placement?(board, size, coords, direction)
  end

  defp healthy_ships(%{squares: squares}) do
    Battleship.constants[:default_ships]
    |> Enum.filter(&(!Enum.member?(hit_ship_ids(squares), &1.id)))
  end

  defp hit_ship_ids(squares) do
    squares
    |> Enum.filter(&(&1.status == Battleship.constants.hit))
    |> Enum.map(&(&1.ship.id))
    |> Enum.uniq
  end
end

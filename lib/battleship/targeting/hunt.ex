defmodule Battleship.Targeting.Hunt do
  def guess(board) do
    IO.puts "HUNT"
    IO.inspect healthy_ships(board)

    probabilities =
      (for index <- 0..board.row_length * board.row_length - 1, do: 0)
      |> increment_probabilities(board, 4)
      |> IO.inspect
  end

  defp increment_probabilities(probabilities, board, size) do
    calculated_probabilities = calculate_probabilities(board, size)
    for i <- 0..Enum.count(probabilities) - 1, do: Enum.at(probabilities, i) + Enum.at(calculated_probabilities, i)
  end

  defp calculate_probabilities(board, size) do
    for x <- 1..board.row_length, y <- 1..board.row_length do
      probability = 0
      if valid_placement?(board, size, {x, y}, :horizontal), do: probability = probability + 1
      if valid_placement?(board, size, {x, y}, :vertical), do: probability = probability + 1
      IO.inspect {x, y}
      IO.inspect probability
      probability
    end
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

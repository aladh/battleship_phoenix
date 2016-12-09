defmodule Battleship.Targeting.Hunt do
  def guess(board) do
    IO.puts "HUNT"
    IO.inspect healthy_ships(board)

    probabilities =
      (for index <- 0..board.row_length * board.row_length - 1, do: 0)
      |> sum_probabilities(board, healthy_ships(board))

    IO.inspect probabilities

    max = Enum.max(probabilities)

    index = Enum.find_index(probabilities, &(&1 == max))

    IO.puts "Guess #{index}"
    index
  end

  defp sum_probabilities(probabilities, board, healthy_ships) do
    Enum.reduce(healthy_ships, probabilities, &(increment_probabilities(&2, board, &1.size)))
  end

  defp increment_probabilities(probabilities, board, size) do
    calculated_probabilities = calculate_probabilities(board, size)
    for i <- 0..Enum.count(probabilities) - 1, do: Enum.at(probabilities, i) + Enum.at(calculated_probabilities, i)
  end

  defp calculate_probabilities(board, size) do
    for y <- 1..board.row_length, x <- 1..board.row_length do
      probability = 0
      if valid_placement?(board, size, {x, y}, :horizontal), do: probability = probability + 1
      if valid_placement?(board, size, {x, y}, :vertical), do: probability = probability + 1
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

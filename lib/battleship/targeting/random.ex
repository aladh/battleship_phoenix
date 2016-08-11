defmodule Battleship.Targeting.Random do
  def guess(unrevealed_indices, board) when length(unrevealed_indices) > 1 do
    IO.puts "Random guess"

    index = Enum.random(unrevealed_indices)
    if valid_guess?(index, board) do
      index
    else
      new_indices = Enum.reject(unrevealed_indices, &(&1 == index))
      guess(new_indices, board)
    end
  end

  def guess([unrevealed_index], _board), do: unrevealed_index

  def guess([], _board), do: nil

  defp valid_guess?(index, board) do
    IO.inspect neighbour_indices(index)
    true
  end

  def neighbour_indices(index) do
    IO.inspect index
    [
      left_neighbour(index),
      right_neighbour(index),
      upper_neighbour(index),
      lower_neighbour(index)
    ]
    |> Enum.reject(&(&1 == nil))
  end

  defp upper_neighbour(index) do
    neighbour = index - Battleship.constants.row_length
    if valid_index?(neighbour), do: neighbour
  end

  defp lower_neighbour(index) do
    neighbour = index + Battleship.constants.row_length
    if valid_index?(neighbour), do: neighbour
  end

  defp left_neighbour(index) do
    neighbour = index - 1
    if !first_in_row?(index), do: neighbour
  end

  defp right_neighbour(index) do
    neighbour = index + 1
    if !last_in_row?(index), do: neighbour
  end

  defp first_in_row?(index), do: rem(index, Battleship.constants.row_length) == 0

  defp last_in_row?(index), do: rem(index + 1, Battleship.constants.row_length) == 0

  defp valid_index?(index), do: index in 0..(Battleship.constants.row_length * Battleship.constants.row_length) - 1
end

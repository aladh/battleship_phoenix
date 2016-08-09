defmodule Battleship.Targeting.Proximity.Index do
  def guess(square_index, guess_index, board) when guess_index == square_index - 1 do
    if first_in_row(square_index), do: IO.puts "blocking left guess (#{guess_index}) for square at #{square_index}"
    if valid_guess?(guess_index, board) && !first_in_row(square_index), do: guess_index
  end

  def guess(square_index, guess_index, board) when guess_index == square_index + 1 do
    if last_in_row(square_index), do: IO.puts "blocking right guess (#{guess_index}) for square at #{square_index}"
    if valid_guess?(guess_index, board) && !last_in_row(square_index), do: guess_index
  end

  def guess(_square_index, guess_index, board) do
    if valid_guess?(guess_index, board), do: guess_index
  end

  defp first_in_row(index), do: rem(index, 8) == 0

  defp last_in_row(index), do: rem(index + 1, 8) == 0

  defp valid_guess?(index, board) do
    revealed = Enum.at(board.squares, index)
    |> Battleship.Square.revealed?
    valid_index = index in 0..(Battleship.constants.row_length * Battleship.constants.row_length) - 1
    !revealed && valid_index
  end
end

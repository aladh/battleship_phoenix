defmodule Battleship.Targeting.Proximity do
  def guess([ship_squares | _rest], board) do
    ship_squares |> ship_guess(board)
  end

  defp ship_guess([square | rest], board) do
    guess =
      square
      |> square_guess(board)
    if guess, do: guess, else: ship_guess(rest, board)
  end

  defp ship_guess([], _board) do
    nil
  end

  defp square_guess(square, board) do
    cond do
      index_guess(square.index - 1, board) ->
        IO.puts "Guessing left"
        index_guess(square.index - 1, board)
      index_guess(square.index + 1, board) ->
        IO.puts "Guessing right"
        index_guess(square.index + 1, board)
      index_guess(square.index - Battleship.constants.row_length, board) ->
        IO.puts "Guessing one row above"
        index_guess(square.index - Battleship.constants.row_length, board)
      index_guess(square.index + Battleship.constants.row_length, board) ->
        IO.puts "Guessing one row below"
        index_guess(square.index + Battleship.constants.row_length, board)
      true ->
        nil
    end
  end

  defp index_guess(index, board) do
    if valid_guess?(index, board), do: index
  end

  defp valid_guess?(index, board) do
    revealed = Enum.at(board.squares, index)
    |> Battleship.Square.revealed?
    valid_index = index in 0..(Battleship.constants.row_length * Battleship.constants.row_length) - 1
    !revealed && valid_index
  end
end

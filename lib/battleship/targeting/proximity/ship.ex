defmodule Battleship.Targeting.Proximity.Ship do
  def guess([square | rest], board) do
    guess_index =
      square
      |> Battleship.Targeting.Proximity.Square.guess(board)
    if guess_index, do: guess_index, else: guess(rest, board)
  end

  # defp guess([], _board), do: nil
end

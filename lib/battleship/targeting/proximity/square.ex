defmodule Battleship.Targeting.Proximity.Square do
  def guess(square, board) do
    index = square.index
    cond do
      guess_index = left_guess(index, board) -> guess_index
      guess_index = right_guess(index, board) -> guess_index
      guess_index = up_guess(index, board) -> guess_index
      guess_index = down_guess(index, board) -> guess_index
      true -> nil
    end
  end

  def guess(square, board, direction: :vertical) do
    index = square.index
    cond do
      guess_index = up_guess(index, board) -> guess_index
      guess_index = down_guess(index, board) -> guess_index
      true -> nil
    end
  end

  def guess(square, board, direction: :horizontal) do
    index = square.index
    cond do
      guess_index = left_guess(index, board) -> guess_index
      guess_index = right_guess(index, board) -> guess_index
      true -> nil
    end
  end

  defp left_guess(square_index, board) do
    Battleship.Targeting.Proximity.Index.guess(square_index, square_index - 1, board)
  end

  defp right_guess(square_index, board) do
    Battleship.Targeting.Proximity.Index.guess(square_index, square_index + 1, board)
  end

  defp up_guess(square_index, board) do
    Battleship.Targeting.Proximity.Index.guess(square_index, square_index - Battleship.constants.row_length, board)
  end

  defp down_guess(square_index, board) do
    Battleship.Targeting.Proximity.Index.guess(square_index, square_index + Battleship.constants.row_length, board)
  end
end

defmodule Battleship.Targeting do
  def guess(board) do
    unrevealed_indices = Battleship.Board.unrevealed_square_indices(board)
    with true <- (length = length(unrevealed_indices)) > 0 do
      index = :rand.uniform(length) - 1
      Enum.at(unrevealed_indices, index)
    end
  end
end

defmodule Battleship.Targeting do
  def guess(board = %{row_length: row_length}) do
    coord = {:rand.uniform(row_length), :rand.uniform(row_length)}
    if Battleship.Board.square_revealed?(board, coord) do
      guess(board)
    else
      coord
    end
  end
end

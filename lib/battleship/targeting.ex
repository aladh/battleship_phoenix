defmodule Battleship.Targeting do
  def guess(board) do
    unrevealed_indices = Battleship.Board.unrevealed_square_indices(board)
    if length(unrevealed_indices) > 0 do
      target_ships = partially_hit_ships(board)
      if length(target_ships) > 0 do
        Battleship.Targeting.Proximity.guess(target_ships, board)
      else
        random_guess(unrevealed_indices)
      end
    end
  end

  defp random_guess(indices) do
    Enum.random(indices)
  end

  defp partially_hit_ships(board) do
    board.squares
    |> Enum.filter(&(&1.status == Battleship.constants.hit))
    |> Enum.group_by(&(&1.ship.id))
    |> Enum.map(fn({id, hit_squares}) -> if ship_alive?(id, hit_squares), do: hit_squares end)
    |> Enum.reject(&(&1 == nil))
  end

  defp ship_alive?(id, hit_squares) do
    Battleship.constants.default_ships
    |> Enum.find(&(&1.id == id))
    |> (&(&1.size > length(hit_squares))).()
  end
end

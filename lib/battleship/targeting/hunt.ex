defmodule Battleship.Targeting.Hunt do
  def guess(board) do
    IO.puts "HUNT"
    IO.inspect healthy_ships(board)
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

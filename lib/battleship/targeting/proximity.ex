defmodule Battleship.Targeting.Proximity do
  def guess([ship_squares | _rest], board) do
    ship_squares |> Battleship.Targeting.Proximity.Ship.guess(board)
  end
end

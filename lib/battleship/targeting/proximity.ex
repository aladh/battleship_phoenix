defmodule Battleship.Targeting.Proximity do
  def guess([[ship_square] | _rest], board) do
    IO.puts "Proximity: single"
    Battleship.Targeting.Proximity.Ship.guess([ship_square], board)
  end

  def guess([ship_squares | _rest], board) do
    IO.puts "Proximity: multi"
    Battleship.Targeting.Proximity.LayoutDetector.guess(ship_squares, board)
  end
end

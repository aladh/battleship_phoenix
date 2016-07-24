defmodule Battleship.Ship do
  @derive [Poison.Encoder]
  defstruct size: 2, id: 1, name: "Destroyer"
end

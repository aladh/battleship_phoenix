defmodule Battleship.Square do
  @derive [Poison.Encoder]
  defstruct status: Battleship.constants[:untouched], ship: nil

  def empty?(%{ship: nil}), do: true
  def empty?(_), do: false
end

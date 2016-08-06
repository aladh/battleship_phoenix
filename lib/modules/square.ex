defmodule Battleship.Square do
  defstruct status: Battleship.constants[:untouched], ship: nil, index: nil

  def empty?(%{ship: nil}), do: true
  def empty?(_), do: false

  def revealed?(square) do
    square.status == Battleship.constants[:hit] || square.status == Battleship.constants[:miss]
  end
end

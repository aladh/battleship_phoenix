defmodule Battleship.Square do
  defstruct status: Battleship.constants[:untouched], ship: nil, index: nil
  @hit Battleship.constants.hit
  @miss Battleship.constants.miss

  def empty?(%{ship: nil}), do: true
  def empty?(_), do: false

  def revealed?(%{status: @hit}), do: true
  def revealed?(%{status: @miss}), do: true
  def revealed?(_), do: false
end

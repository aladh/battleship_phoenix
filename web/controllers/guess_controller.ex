defmodule Battleship.GuessController do
  use Battleship.Web, :controller

  def show(conn, params) do
    index = %Battleship.Board{squares: Poison.decode!(params["squares"], keys: :atoms!)}
    |> Battleship.Targeting.guess
    json conn, index
  end
end

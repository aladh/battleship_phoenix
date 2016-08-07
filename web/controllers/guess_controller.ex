defmodule Battleship.GuessController do
  use Battleship.Web, :controller

  def show(conn, %{"squares" => squares}) do
    guess_index =
      %Battleship.Board{squares: Poison.decode!(squares, keys: :atoms!)}
      |> Battleship.Targeting.guess

    json conn, guess_index
  end
end

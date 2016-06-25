defmodule Battleship.GuessController do
  use Battleship.Web, :controller

  def show(conn, _params) do
    json conn, %{x: 1, y: 2}
  end
end

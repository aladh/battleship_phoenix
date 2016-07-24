defmodule Battleship.BoardController do
  use Battleship.Web, :controller

  def new(conn, _params) do
    json conn, Battleship.Board.new
  end
end

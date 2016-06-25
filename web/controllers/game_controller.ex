defmodule Battleship.GameController do
  use Battleship.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end
end

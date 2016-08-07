defmodule Battleship.LayoutView do
  use Battleship.Web, :view

  def render_analytics do
    Mix.env != :dev
  end
end

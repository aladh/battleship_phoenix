defmodule Battleship.LayoutView do
  @mix_env Mix.env
  use Battleship.Web, :view

  def render_analytics do
    @mix_env != :dev
  end
end

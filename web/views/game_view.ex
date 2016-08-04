defmodule Battleship.GameView do
  use Battleship.Web, :view

  def react_component(class, props \\ []) do
    json_props =
      props
      |> Enum.into(%{})
      |> Poison.encode!
    raw "<div data-react-class=\"#{class}\" data-react-props=#{json_props}></div>"
  end
end

defmodule Battleship do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(Battleship.Endpoint, []),
      # Start your own worker by calling: Battleship.Worker.start_link(arg1, arg2, arg3)
      # worker(Battleship.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Battleship.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Battleship.Endpoint.config_change(changed, removed)
    :ok
  end

  def constants do
    %{untouched: 0,
      miss: 1,
      hit: 3,
      placed_ship: 4,
      row_length: 10,
      default_ships: [%Battleship.Ship{name: "Battleship", size: 4, id: 1},
                      %Battleship.Ship{name: "Submarine", size: 3, id: 2},
                      %Battleship.Ship{name: "Destroyer", size: 2, id: 3},
                      %Battleship.Ship{name: "Destroyer", size: 2, id: 4}]
    }
  end
end

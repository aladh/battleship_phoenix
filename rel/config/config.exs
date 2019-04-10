use Mix.Config

port = case System.get_env("PORT") do
    nil -> 8888
    value -> String.to_integer(value)
end

config :battleship, Battleship.Endpoint,
  http: [port: port]
defmodule Dairon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: Dairon.DevServer, scheme: :http, port: 3000}
    ]

    Logger.info("Development site serving at: http://localhost:3000")
    Supervisor.start_link(children, strategy: :one_for_one, name: Dairon.Supervisor)
  end
end

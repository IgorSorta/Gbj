defmodule Gbj.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Gbj.Worker.start_link(arg)
      {Cluster.Supervisor, [topologies(), [name: Gbj.ClusterSupervisor]]},
      {Gbj.DBCleaner.Starter, [timeout: :timer.seconds(2)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gbj.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def topologies() do
    [
      background_job: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
  end
end

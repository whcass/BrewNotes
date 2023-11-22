defmodule Brewnotes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BrewnotesWeb.Telemetry,
      Brewnotes.Repo,
      {DNSCluster, query: Application.get_env(:brewnotes, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Brewnotes.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Brewnotes.Finch},
      # Start a worker by calling: Brewnotes.Worker.start_link(arg)
      # {Brewnotes.Worker, arg},
      # Start to serve requests, typically the last entry
      BrewnotesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Brewnotes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BrewnotesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

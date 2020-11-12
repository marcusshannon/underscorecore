defmodule Underscorecore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Underscorecore.Repo,
      # Start the Telemetry supervisor
      UnderscorecoreWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Underscorecore.PubSub},
      # Start the Endpoint (http/https)
      UnderscorecoreWeb.Endpoint,
      # Start a worker by calling: Underscorecore.Worker.start_link(arg)
      # {Underscorecore.Worker, arg}
      {Finch, name: Underscorecore.Finch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Underscorecore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UnderscorecoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

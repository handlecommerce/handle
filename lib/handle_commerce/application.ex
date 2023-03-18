defmodule HandleCommerce.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HandleCommerceWeb.Telemetry,
      # Start the Ecto repository
      HandleCommerce.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: HandleCommerce.PubSub},
      # Start Finch
      {Finch, name: HandleCommerce.Finch},
      # Start the Endpoint (http/https)
      HandleCommerceWeb.Endpoint,
      # Start caching server
      {Cachex, name: :handle_commerce_cache}
      # Start a worker by calling: HandleCommerce.Worker.start_link(arg)
      # {HandleCommerce.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HandleCommerce.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HandleCommerceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

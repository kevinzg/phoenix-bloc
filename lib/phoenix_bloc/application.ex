defmodule PhoenixBloc.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(PhoenixBloc.Web.Endpoint, []),
      # Start your own worker by calling: PhoenixBloc.Worker.start_link(arg1, arg2, arg3)
      # worker(PhoenixBloc.Worker, [arg1, arg2, arg3]),

      # Redix worker
      # See http://hexdocs.pm/redix/real-world-usage.html#global-redix
      worker(Redix, [[host: "redis"], [name: :redix]]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixBloc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

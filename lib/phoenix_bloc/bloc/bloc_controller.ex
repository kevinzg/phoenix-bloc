defmodule PhoenixBloc.Bloc.BlocController do
  alias Redix

  def get_bloc(bloc_id) do
    case Redix.command(:redix, ~w(HMGET bloc:#{bloc_id} rev content)) do
      {:ok, [:nil, _]} -> {:ok, 0, nil}
      {:ok, [rev, content]} -> {:ok, rev, content}
    end
  end
end

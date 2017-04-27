defmodule PhoenixBloc.Bloc.BlocController do
  alias Redix

  def get_bloc(bloc_id) do
    case Redix.command(:redix, ~w(HMGET bloc:#{bloc_id}:content rev content)) do
      {:ok, [:nil, _]} -> {:ok, 0, nil}
      {:ok, [rev, content]} -> {:ok, rev, content}
    end
  end

  def apply_delta(bloc_id, rev, delta) do
    {:ok, rev, content} = get_bloc(bloc_id)
    rev_x = String.to_integer(rev) |> Kernel.+(1)
    Redix.command!(:redix, ["HMSET", "bloc:#{bloc_id}", "rev", "#{rev_x}", "content", "#{content}"])
    {:ok}
  end
end

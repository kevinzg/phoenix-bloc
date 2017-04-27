defmodule PhoenixBloc.Bloc.BlocController do
  alias Redix

  def get_bloc(bloc_id) do
    case Redix.command(:redix, ~w(HMGET bloc:#{bloc_id}:content rev content)) do
      {:ok, [:nil, _]} -> {:ok, 0, nil}
      {:ok, [rev, content]} -> {:ok, rev, content}
    end
  end

  def apply_delta(%{"bloc_id" => bloc_id, "parent_rev" => parent_rev,
    "delta" => delta}) do

    new_rev = parent_rev + 1
    new_delta = %{"rev" => new_rev, "delta" => delta}

    {:ok, json_delta} = Poison.encode(new_delta)
    Redix.command!(:redix, ["RPUSH", "bloc:#{bloc_id}:deltas", json_delta])
    Redix.command!(:redix, ["HSET", "bloc:#{bloc_id}", "rev", new_rev])

    {:ok, new_rev, delta}
  end

  def get_deltas_from_revision(bloc_id, rev) do
    {:ok, deltas} = Redix.command(:redix, ~w(LRANGE bloc:#{bloc_id}:deltas #{rev} -1))
    {:ok, deltas}
  end
end

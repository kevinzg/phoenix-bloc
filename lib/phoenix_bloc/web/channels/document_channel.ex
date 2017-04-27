defmodule PhoenixBloc.Web.DocumentChannel do
  alias PhoenixBloc.Bloc.BlocController
  use PhoenixBloc.Web, :channel

  def join("document:lobby", payload, socket) do
    %{"parent_rev" => rev, "bloc_id" => bloc_id} = payload
    {:ok, deltas} = BlocController.get_deltas_from_revision(bloc_id, rev)

    if authorized?(payload) do
      {:ok, deltas, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (document:lobby).
  def handle_in("shout", payload, socket) do
    {:ok, rev, delta} = BlocController.apply_delta(payload)

    new_payload = payload
      |> Map.put("rev", rev)
      |> Map.put("delta", delta)

    broadcast socket, "shout", new_payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

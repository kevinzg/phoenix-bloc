defmodule PhoenixBloc.Web.DocumentChannel do
  alias PhoenixBloc.Bloc.BlocController
  use PhoenixBloc.Web, :channel

  def join("document:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
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
    broadcast socket, "shout", payload

    %{"bloc_id" => bloc_id, "rev" => rev, "delta" => delta} = payload
    BlocController.apply_delta(bloc_id, rev, delta)

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

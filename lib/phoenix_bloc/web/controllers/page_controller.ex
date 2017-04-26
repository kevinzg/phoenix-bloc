defmodule PhoenixBloc.Web.PageController do
  alias Redix
  use PhoenixBloc.Web, :controller
  import PhoenixBloc.Bloc.BlocController

  def index(conn, _params) do
    bloc_id = "default"
    {:ok, rev, content} = get_bloc(bloc_id)
    render conn, "index.html", id: bloc_id, rev: rev, content: content
  end
end

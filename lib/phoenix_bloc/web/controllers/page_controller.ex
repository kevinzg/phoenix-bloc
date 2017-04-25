defmodule PhoenixBloc.Web.PageController do
  use PhoenixBloc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

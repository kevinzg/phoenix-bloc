defmodule PhoenixBloc.Web.Router do
  use PhoenixBloc.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixBloc.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/:id", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixBloc.Web do
  #   pipe_through :api
  # end
end

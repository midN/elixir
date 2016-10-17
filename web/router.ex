defmodule Stockman.Router do
  use Stockman.Web, :router

  pipeline :exq do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: Stockman.Token
    plug Stockman.Plug.EnsureAdmin
    plug ExqUi.RouterPlug, namespace: "exq"
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Stockman.Plug.CurrentUser
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Stockman.Token
  end

  scope "/", Stockman do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", Stockman do
    pipe_through [:browser, :browser_auth]

    resources "/converts", ConvertController do
      get "/fetch_rates", ConvertController, :fetch_rates, as: :ft
    end
  end

  scope "/exq", ExqUi do
    pipe_through :exq
    forward "/", RouterPlug.Router, :index
  end
end

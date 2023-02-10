defmodule ExCommerce.Routers.HostedRouter do
  use ExCommerceWeb, :router

  import ExCommerceWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ExCommerceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/", ExCommerceWeb do
    # Use the default browser stack
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", Subdomainer do
  #   pipe_through :api
  # end
end

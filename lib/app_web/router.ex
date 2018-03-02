defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AppWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    get "/users/:username", UserController, :show
    post "/auth", UserController, :authenticate
    resources "/posts", PostController, except: [:new, :edit]
    resources "/comments", CommentController, except: [:new, :edit]
  end
end

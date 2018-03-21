defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AppWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    post "/auth", UserController, :authenticate
    resources "/posts", PostController, except: [:new, :edit] do
      resources "/comments", CommentController, except: [:new, :edit]
    end

  end
end

defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AppWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    get "/users/:username", UserController, :show
    get "/profile/:username", UserController, :profile
    post "/auth", UserController, :authenticate
    get "/home", PostController, :home


    resources "/posts", PostController, except: [:new, :edit]

    resources "/comments", CommentController, except: [:new, :edit]
    post "/posts/:post_id/comments", CommentController, :create
    #get "/posts/:post_id/comments", CommentController, :create
  end
end

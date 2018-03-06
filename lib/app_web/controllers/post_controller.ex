defmodule AppWeb.PostController do
  use AppWeb, :controller

  alias App.Thread
  alias App.Thread.Post

  action_fallback AppWeb.FallbackController

  plug (AppWeb.Services.Plugs.UserPlug when action in [:show, :create, :home, :update, :delete, :index])

  def index(conn, _params) do
    posts = Thread.list_posts(conn.assigns.user)
    render(conn, "index_with_details.json", posts: posts)
  end

  def home(conn, _params) do
    posts = Thread.list_all_posts()
    comments = Thread.list_comments()
    render(conn, "index_with_details.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Thread.create_post(post_params, conn.assigns.user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Thread.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Thread.get_post!(id)

    with {:ok, %Post{} = post} <- Thread.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Thread.get_post!(id)
    with {:ok, %Post{}} <- Thread.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end

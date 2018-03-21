defmodule AppWeb.CommentController do
  use AppWeb, :controller

  alias App.Thread
  alias App.Thread.Comment
  alias AppWeb.Utils.ErrorUtils

  action_fallback AppWeb.FallbackController

  plug (AppWeb.Services.Plugs.UserPlug when action in [:show, :create, :update, :delete, :index])

  def index(conn, _params) do
    comments = Thread.list_comments()
    render(conn, "index_with_comment.json", comments: comments)
  end

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Thread.create_comment(comment_params, conn.assigns.user, post_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_comment_path(conn, :show, post_id, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Thread.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Thread.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Thread.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Thread.get_comment!(id)

    if conn.assigns.user.id == comment.user_id do
      with {:ok, %Comment{}} <- Thread.delete_comment(comment) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> ErrorUtils.throw(:unauthorized, reason: "Cannot delete other user comment.")
    end
  end
end

defmodule AppWeb.CommentView do
  use AppWeb, :view
  alias AppWeb.CommentView
  alias AppWeb.UserView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      content: comment.content
  }
  end

  def render("index_with_comment.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment_with_user.json")}
  end

  def render("comment_with_user.json", %{comment: comment}) do
    %{id: comment.id,
      content: comment.content,
      user: render_one(comment.user, UserView, "home_users.json")
  }
  end

  def render("comment_without_user.json", %{comment: comment}) do
    %{id: comment.id,
      content: comment.content
  }
  end
end

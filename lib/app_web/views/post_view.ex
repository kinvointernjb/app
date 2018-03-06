defmodule AppWeb.PostView do
  use AppWeb, :view
  alias AppWeb.PostView
  alias AppWeb.UserView
  alias AppWeb.CommentView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      content: post.content
    }
  end

  def render("post_for_user.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      content: post.content,
      comments: render_many(post.comments, CommentView, "comment_without_user.json")
    }
  end

  def render("show_with_details.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("index_with_details.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post_with_details.json")}
  end

  def render("post_with_details.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      content: post.content,
      user: render_one(post.user, UserView, "home_users.json"),
      comments: render_many(post.comments, CommentView, "comment_with_user.json")
    }
  end
end

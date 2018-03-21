defmodule App.ThreadTest do
  use App.DataCase
  use App.UserCase
  alias App.Thread

  describe "posts" do
    alias App.Thread.Post

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def post_fixture(attrs \\ %{}, user) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Thread.create_post(user)
      post
      |> Repo.preload([:user, [comments: :user]])
    end

    def post_fixture_for_get(attrs \\ %{}, user) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Thread.create_post(user)
      post
    end

    test "list_posts/0 returns all posts", %{user: user} do
      post = post_fixture(user)
      assert Thread.list_posts(user) == [post]
    end

    test "get_post!/1 returns the post with given id", %{user: user} do
      post = post_fixture_for_get(user)
      assert Thread.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post", %{user: user} do
      assert {:ok, %Post{} = post} = Thread.create_post(@valid_attrs, user)
      assert post.content == "some content"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Thread.create_post(@invalid_attrs, user)
    end

    test "update_post/2 with valid data updates the post", %{user: user} do
      post = post_fixture(user)
      assert {:ok, post} = Thread.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.content == "some updated content"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset", %{user: user} do
      post = post_fixture_for_get(user)
      assert {:error, %Ecto.Changeset{}} = Thread.update_post(post, @invalid_attrs)
      assert post == Thread.get_post!(post.id)
    end

    test "delete_post/1 deletes the post", %{user: user} do
      post = post_fixture_for_get(user)
      assert {:ok, %Post{}} = Thread.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Thread.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset", %{user: user} do
      post = post_fixture(user)
      assert %Ecto.Changeset{} = Thread.change_post(post)
    end
  end

  describe "comments" do
    alias App.Thread.Comment

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}
    @post_attrs %{content: "some content", title: "some title"}
    def fixture(:post, user) do
      {:ok, post} = Thread.create_post(@post_attrs, user)
      post
    end

    def comment_fixture(attrs \\ %{}, user, post) do

      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Thread.create_comment(user, post)
      comment
      |> Repo.preload(:user)
    end

    def comment_fixture_for_get(attrs \\ %{}, user, post) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Thread.create_comment(user, post)
      comment
    end

    test "list_comments/0 returns all comments", %{user: user} do
      post = post_fixture_for_get(user)
      comment = comment_fixture(user, post.id |> Integer.to_string())
      assert Thread.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id", %{user: user} do
      post = post_fixture_for_get(user)
      comment = comment_fixture_for_get(user, post.id |> Integer.to_string())
      assert Thread.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment", %{user: user} do
      post = post_fixture_for_get(user)
      assert {:ok, %Comment{} = comment} = Thread.create_comment(@valid_attrs, user, post.id |> Integer.to_string())
      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset", %{user: user} do
      post = post_fixture_for_get(user)
      assert {:error, %Ecto.Changeset{}} = Thread.create_comment(@invalid_attrs, user, post.id |> Integer.to_string())
    end

    test "update_comment/2 with valid data updates the comment", %{user: user} do
      post = post_fixture_for_get(user)
      comment = comment_fixture(user, post.id |> Integer.to_string())
      assert {:ok, comment} = Thread.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset", %{user: user} do
      post = post_fixture_for_get(user)
      comment = comment_fixture_for_get(user, post.id |> Integer.to_string())
      assert {:error, %Ecto.Changeset{}} = Thread.update_comment(comment, @invalid_attrs)
      assert comment == Thread.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment", %{user: user} do
      post = post_fixture_for_get(user)
      comment = comment_fixture_for_get(user, post.id |> Integer.to_string())
      assert {:ok, %Comment{}} = Thread.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Thread.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset", %{user: user} do
      post = post_fixture_for_get(user)
      comment = comment_fixture_for_get(user, post.id |> Integer.to_string())
      assert %Ecto.Changeset{} = Thread.change_comment(comment)
    end
  end
end

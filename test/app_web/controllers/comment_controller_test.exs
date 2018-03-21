defmodule AppWeb.CommentControllerTest do
  use AppWeb.ConnCase
  use App.UserCase
  alias App.Thread
  alias App.Thread.Comment

  @create_attrs %{content: "Test comment"}
  @post_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "updated content"}
  @invalid_attrs %{content: nil}

  def fixture(:comment, user, post) do
    {:ok, comment} = Thread.create_comment(@create_attrs, user, post)
    comment
  end

  def fixture(:post, user) do
    {:ok, post} = Thread.create_post(@post_attrs, user)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:put_valid_token]

    test "lists all comments", %{conn: conn} do
      get_conn = get conn, post_comment_path(conn, :index, 0)
      assert json_response(get_conn, 200)["data"] == []
    end
  end

  describe "create comment" do
    setup [:put_valid_token]
    setup [:create_post]

    test "renders comment when data is valid", %{conn: conn, post: post} do
      conn = post conn, post_comment_path(conn, :create, post.id, []), comment: @create_attrs
      assert %{} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = post conn, post_comment_path(conn, :create, post.id, []), comment: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update comment" do
    setup [:put_valid_token]
    setup [:create_post]
    setup [:create_comment]

    test "renders comment when data is valid", %{conn: conn, comment: %Comment{id: id} = comment} do
      conn = put conn, post_comment_path(conn, :update, comment, id), comment: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "content" => "updated content"}
    end

    test "renders errors when data is invalid", %{conn: conn, comment: comment, comment: %Comment{id: id} = comment} do
      conn = put conn, post_comment_path(conn, :update, comment, id), comment: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete comment" do
    setup [:put_valid_token]
    setup [:create_post]
    setup [:create_comment]

    test "deletes chosen comment", %{conn: conn, comment: comment, comment: %Comment{id: id} = comment} do
      conn = delete conn, post_comment_path(conn, :delete, comment, id)
      assert response(conn, 204)
    end
  end

  defp create_comment(%{user: user, post: post}) do
    comment = fixture(:comment, user, post.id |> Integer.to_string())
    {:ok, comment: comment}
  end

  defp create_post(%{user: user}) do
    post = fixture(:post, user)
    {:ok, post: post}
  end

  defp put_valid_token(%{conn: conn, auth_map: auth_map}) do
    {:ok, conn: put_req_header(conn, "authorization", "Bearer #{auth_map.token}")}
  end
end

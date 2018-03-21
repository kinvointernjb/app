defmodule AppWeb.PostControllerTest do
  use AppWeb.ConnCase
  use App.UserCase
  alias App.Thread
  alias App.Thread.Post

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  def fixture(:post, user) do
    {:ok, post} = Thread.create_post(@create_attrs, user)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:put_valid_token]

    test "lists all posts", %{conn: conn} do
      conn = get conn, post_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create post" do
    setup [:put_valid_token]
    test "renders post when data is valid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      assert json_response(conn, 201)["data"] == %{
        "id" => id,
        "content" => "some content",
        "title" => "some title"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update post" do
    setup [:put_valid_token]
    setup [:create_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      conn = put conn, post_path(conn, :update, post), post: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "content" => "some updated content",
        "title" => "some updated title"}
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete post" do
    setup [:put_valid_token]
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete conn, post_path(conn, :delete, post)
      assert response(conn, 204)
    end
  end

  defp create_post(%{user: user}) do
    post = fixture(:post, user)
    {:ok, post: post}
  end

  defp put_valid_token(%{conn: conn, auth_map: auth_map}) do
    {:ok, conn: put_req_header(conn, "authorization", "Bearer #{auth_map.token}")}
  end
end

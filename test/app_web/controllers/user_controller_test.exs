defmodule AppWeb.UserControllerTest do
  use AppWeb.ConnCase

  alias App.Accounts
  alias App.Accounts.User
  alias AppWeb.Services.Authenticator

  @create_attrs %{email: "some@email.com", password: "kinvojb", first_name: "John Benedict", last_name: "Benin", username: "kinvojb"}
  @update_attrs %{email: "some@email.com", password: "some updated encrypted_password", firstname: "some updated firstname", lastname: "some updated lastname"}
  @invalid_attrs %{email: nil, encrypted_password: nil, firstname: nil, lastname: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_user]
    setup [:authenticate_user]

    test "lists all users", %{conn: conn, token: token} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(user_path(conn, :index))
      refute Enum.empty?(json_response(conn, 200)["data"])
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id,
      "inserted_at" => inserted_at,
      "updated_at" => updated_at} = json_response(conn, 201)["data"]

      assert json_response(conn, 201)["data"] == %{
        "id" => id,
        "email" => "some@email.com",
        "first_name" => "John Benedict",
        "last_name" => "Benin",
        "username" => "kinvojb",
        "inserted_at" => inserted_at,
        "updated_at" => updated_at
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]
    setup [:authenticate_user]

    test "renders user when data is valid", %{conn: conn, token: token, user: %User{id: id} = user} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> put(user_path(conn, :update, user), user: @update_attrs)
        assert %{"id" => ^id,
        "inserted_at" => inserted_at,
        "updated_at" => updated_at} = json_response(conn, 200)["data"]

        assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "email" => "some@email.com",
        "first_name" => "John Benedict",
        "last_name" => "Benin",
        "inserted_at" => inserted_at,
        "updated_at" => updated_at,
        "username" => "kinvojb"
        }
    end

    test "renders errors when data is invalid", %{conn: conn, user: user, token: token} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> put(user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]
    setup [:authenticate_user]

    test "deletes chosen user", %{conn: conn, user: user, token: token} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> delete(user_path(conn, :delete, user))
      assert response(conn, 204)
    end
  end

  describe "authenticate_user" do
    setup [:create_user]

    test "render token when user is valid", %{conn: conn} do
      credentials = %{
        username: "kinvojb",
        password: "kinvojb"
      }

      conn =
        conn
        |> post(user_path(conn, :authenticate, credentials))

      assert response(conn, 200)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp authenticate_user(_) do
    with {:ok, user_with_token} <- Authenticator.authorize("kinvojb", "kinvojb") do
      {:ok, token: user_with_token.token}
    end
  end
end

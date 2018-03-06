defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Accounts.User
  import Comeonin.Bcrypt
  alias App.Thread.Post
  alias App.Thread.Comment

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :password, :string, virtual: true
    has_many :posts, Post
    has_many :comments, Comment
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :username, :password])
    |> validate_required([:first_name, :last_name, :email, :username, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint(:email)
    |> encrypt_password
  end

  defp encrypt_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, add_hash(password, hash_key: :encrypted_password))
  end

  defp encrypt_password(changeset), do: changeset
end

defmodule App.Thread.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Thread.Post
  alias App.Accounts.User
  alias App.Thread.Comment

  schema "posts" do
    field :content, :string
    field :title, :string
    #field :user_id, :id
    belongs_to :user, User
    has_many :comments, Comment
    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end

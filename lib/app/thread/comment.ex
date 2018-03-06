defmodule App.Thread.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Thread.Comment
  alias App.Accounts.User
  alias App.Thread.Post


  schema "comments" do
    # field :user_id, :id
    #field :post_id, :id
    field :content, :string
    belongs_to :user, User
    belongs_to :post, Post
    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end

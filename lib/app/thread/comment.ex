defmodule App.Thread.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Thread.Comment
  alias App.Thread.Post

  schema "comments" do
    field :content, :string
    #field :post_id, :id
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

defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts" do
    field :body, :string
    field :published_at, :naive_datetime
    field :subtitle, :string
    field :tags, {:array, :string}
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :subtitle, :tags, :body, :published_at])
    |> validate_required([:title, :subtitle, :tags, :body, :published_at])
  end
end

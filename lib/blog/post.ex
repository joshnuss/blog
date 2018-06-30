defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    field(:permalink, :string)
    field(:subtitle, :string)
    field(:tags, {:array, :string})
    field(:body, :string)
    field(:published_at, :naive_datetime)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :permalink, :subtitle, :tags, :body])
    |> validate_required([:title, :permalink])
    |> unique_constraint(:permalink)
  end
end

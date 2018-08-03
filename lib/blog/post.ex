defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    field(:permalink, :string)
    field(:subtitle, :string, default: "")
    field(:tags, {:array, :string}, default: [])
    field(:content, :string, default: "")
    field(:content_html, :string, default: "")
    field(:published_at, :naive_datetime)

    timestamps()
  end

  def create(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:title, :permalink, :subtitle, :tags, :content, :content_html])
    |> validate_required([:title, :permalink])
    |> unique_constraint(:permalink)
  end

  def update(post, attrs) do
    post
    |> cast(attrs, [:title, :permalink, :subtitle, :tags, :content, :content_html, :published_at])
    |> validate_required([:title, :permalink])
    |> unique_constraint(:permalink)
  end
end

defmodule Blog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string)
      add(:subtitle, :string)
      add(:tags, {:array, :string})
      add(:body, :text)
      add(:published_at, :naive_datetime)

      timestamps()
    end
  end
end

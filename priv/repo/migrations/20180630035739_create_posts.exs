defmodule Blog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string, null: false)
      add(:permalink, :string, null: false)
      add(:subtitle, :string)
      add(:tags, {:array, :string})
      add(:content, :text)
      add(:published_at, :naive_datetime)

      timestamps()
    end

    create(unique_index(:posts, :permalink))
    create(index(:posts, :published_at))
  end
end

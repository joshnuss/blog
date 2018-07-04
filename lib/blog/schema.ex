defmodule Blog.Schema do
  use Absinthe.Schema

  alias Blog.{Post, Repo}

  @desc "A blog post"
  object :post do
    @desc "The post's heading"
    field :title, :string

    @desc "A unique identifier, usually based on the title"
    field :permalink, :string

    #@desc "The permanent URL of the page"
    #field :url, :string do
    #end

    @desc "The post's subheading"
    field :subtitle, :string

    @desc "A list of tags describing the topics"
    field :tags, %Absinthe.Type.List{of_type: :string}

    @desc "The main content of the post"
    field :body, :string

    #@desc "The date/time the post was published"
    #field :published_at, :datetime
  end

  query do
    field :posts, list_of(:post) do
      resolve fn _, _ ->
        {:ok, Post |> Repo.all}
      end
    end
  end
end

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
      # todo add filters by tag, search
      # sort by published_at desc
      resolve fn _, _ ->
        {:ok, Post |> Repo.all}
      end
    end

    @desc "Find posts by year"
    field :posts_by_year, list_of(:post) do

      @desc "The year to filter by"
      arg :year, :integer

      resolve fn args, _ ->
        {:ok, Blog.find_posts_for_year(args.year)}
      end
    end

    @desc "Find posts by month"
    field :posts_by_month, list_of(:post) do

      @desc "The year to filter by"
      arg :year, :integer

      @desc "The month to filter by"
      arg :month, :integer

      resolve fn args, _ ->
        {:ok, Blog.find_posts_for_month(args.year, args.month)}
      end
    end

    @desc "Find posts by date"
    field :posts_by_date, list_of(:post) do

      @desc "The year to filter by"
      arg :year, :integer

      @desc "The month to filter by"
      arg :month, :integer

      @desc "The day to filter by"
      arg :day, :integer

      resolve fn args, _ ->
        {:ok, Blog.find_posts_for_date(args.year, args.month, args.day)}
      end
    end
  end
end

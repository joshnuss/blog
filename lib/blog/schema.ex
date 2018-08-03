defmodule Blog.Schema do
  use Absinthe.Schema

  alias Blog.{Post, Repo}

  import_types(Absinthe.Type.Custom)

  @desc "A blog post"
  object :post do
    @desc "The post's id"
    field(:id, :id)

    @desc "The post's heading"
    field(:title, :string)

    @desc "A unique identifier, usually based on the title"
    field(:permalink, :string)

    @desc "The post's URL"
    field :url, :string do
      resolve(fn _args, %{source: post} ->
        published_at = post.published_at
        {:ok, "http://foo.bar/posts/#{published_at.year}/#{published_at.month}/#{post.permalink}"}
      end)
    end

    @desc "The post's subheading"
    field(:subtitle, :string)

    @desc "A list of tags describing the topics"
    field(:tags, list_of(:string))

    @desc "The main content of the post"
    field(:body, :string)

    @desc "The date/time the post was published"
    field(:published_at, :naive_datetime)

    @desc "The date/time the post was last updated"
    field(:updated_at, :naive_datetime)
  end

  query do
    field :posts, list_of(:post) do
      # todo add filters by tag, search
      # sort by published_at desc
      resolve(fn _, _ ->
        {:ok, Post |> Repo.all()}
      end)
    end

    @desc "Find a post"
    field :find, :post do
      @desc "The permalink of the post"
      arg(:permalink, :string)

      resolve(fn args, _ ->
        {:ok, Repo.get_by(Post, args)}
      end)
    end

    @desc "Search for posts"
    field :search, list_of(:post) do
      @desc "The year to filter by"
      arg(:year, :integer)

      @desc "The month to filter by"
      arg(:month, :integer)

      @desc "The day to filter by"
      arg(:day, :integer)

      @desc "The tags to filter by"
      arg(:tags, list_of(:string))

      @desc "The search terms to filter by"
      arg(:terms, :string)

      resolve(fn args, _ ->
        {:ok, Blog.find_posts_for_date(args.year, args.month, args.day)}
      end)
    end
  end

  mutation do
    @desc "Create a post"
    field :create, type: :post do
      arg(:title, non_null(:string))
      arg(:permalink, :string)
      arg(:subtitle, :string)
      arg(:tags, list_of(:string))
      arg(:body, non_null(:string))

      resolve(fn _parent, args, _context ->
        format_response(Blog.create_post(args))
      end)
    end

    @desc "Update a post"
    field :update, type: :post do
      arg(:id, :id)
      arg(:title, :string)
      arg(:permalink, :string)
      arg(:subtitle, :string)
      arg(:tags, list_of(:string))
      arg(:body, :string)

      resolve(fn _parent, args, _context ->
        format_response(Blog.update(args.id, args))
      end)
    end

    @desc "Publish a post"
    field :publish, type: :post do
      arg(:id, :id)

      resolve(fn _parent, args, _context ->
        format_response(Blog.publish(args.id))
      end)
    end

    @desc "Unpublish a post"
    field :unpublish, type: :post do
      arg(:id, :id)

      resolve(fn _parent, args, _context ->
        format_response(Blog.unpublish(args.id))
      end)
    end

    @desc "Delete a post"
    field :delete, type: :post do
      arg(:id, :id)

      resolve(fn _parent, args, _context ->
        format_response(Blog.delete(args.id))
      end)
    end
  end

  defp format_response({:error, changeset}) do
    {:error, format_errors(changeset.errors)}
  end

  defp format_response({:ok, post}) do
    {:ok, post}
  end

  defp format_errors(errors) do
    Enum.map(errors, fn {_field, {message, _}} ->
      message
    end)
  end
end

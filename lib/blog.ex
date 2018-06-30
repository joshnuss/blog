defmodule Blog do
  @moduledoc """
  Blog keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Blog.{Repo, Post}

  def post(data) do
    %Post{}
    |> Post.changeset(data)
    |> Repo.insert()
  end
end

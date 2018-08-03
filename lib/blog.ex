defmodule Blog do
  @moduledoc """
  Blog keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Blog.{Repo, Post}

  import Ecto.Query, except: [update: 2]

  def create_post(data) do
    Post.create(data) |> Repo.insert()
  end

  def update(post_id, attrs) when is_number(post_id) or is_binary(post_id) do
    find_post(id: post_id) |> update(attrs)
  end

  def update(post, attrs) do
    post
    |> Post.update(attrs)
    |> Repo.update()
  end

  def publish(post) do
    update(post, %{published_at: NaiveDateTime.utc_now()})
  end

  def unpublish(post) do
    update(post, %{published_at: nil})
  end

  def delete(post_id) when is_number(post_id) or is_binary(post_id) do
    find_post(id: post_id) |> delete()
  end

  def delete(post) do
    Repo.delete(post)
  end

  def find_post(opts) do
    Repo.get_by(Post, opts)
  end

  def find_posts_for_year(year) do
    find_posts_between({year, 1, 1}, {year, 12, 31})
  end

  def find_posts_for_month(year, month) do
    days_in_month = Calendar.ISO.days_in_month(year, month)
    find_posts_between({year, month, 1}, {year, month, days_in_month})
  end

  def find_posts_for_date(year, month, day) do
    find_posts_between({year, month, day}, {year, month, day})
  end

  def find_posts_between(from, to) do
    from_time = NaiveDateTime.from_erl!({from, {0, 0, 0}})
    to_time = NaiveDateTime.from_erl!({to, {11, 59, 59}})

    query =
      from(
        p in Post,
        where: p.published_at >= ^from_time and p.published_at <= ^to_time,
        order_by: [desc: p.published_at],
        select: p
      )

    Repo.all(query)
  end
end

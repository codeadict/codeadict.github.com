defmodule Dairon.Content do
  @moduledoc false

  alias Dairon.Page

  use NimblePublisher,
    build: Page,
    parser: Page,
    from: "./content/**/*.md",
    as: :pages,
    highlighters: [:makeup_erlang, :makeup_elixir, :makeup_js, :makeup_json, :makeup_html],
    earmark_options: [breaks: true, footnotes: true]

  def assert_uniq_page_ids!(pages) do
    ids = pages |> Enum.map(& &1.id)
    dups = Enum.uniq(ids -- Enum.uniq(ids))

    if dups |> Enum.empty?() do
      :ok
    else
      raise "Duplicate pages: #{inspect(dups)}"
    end
  end

  def all_posts do
    @pages |> Enum.filter(&(&1.type == "post")) |> Enum.sort_by(& &1.date, {:desc, Date})
  end

  def active_posts do
    all_posts() |> Enum.reject(& &1.draft)
  end

  def about_page do
    @pages |> Enum.find(&(&1.id == "about"))
  end

  def not_found_page do
    @pages |> Enum.find(&(&1.id == "404"))
  end

  def all_pages do
    [about_page()] ++ active_posts()
  end
end

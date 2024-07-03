defmodule Dairon.Templates do
  @moduledoc """
  Logic and helpers for rendering templates.
  """
  use Phoenix.Component
  import Phoenix.HTML
  import Dairon, only: [site_config: 1]

  alias Dairon.Content

  embed_templates("templates/*")

  @doc """
  Renders all the templates.
  """
  @spec render_all() :: :ok
  def render_all() do
    pages = Content.all_pages()
    all_posts = Content.all_posts()
    about_page = Content.about_page()
    assert_uniq_page_ids!(pages)
    render("index.html", index(%{posts: Content.all_posts()}))
    render("404.html", page(Content.not_found_page()))
    render(about_page.html_path, page(about_page))
    render("archive/index.html", archive(%{posts: all_posts}))
    render_rss("feed.xml", all_posts)
    render("sitemap.xml", sitemap(%{pages: pages}))

    for post <- all_posts do
      render(post.html_path, post(post))
    end

    :ok
  end

  @doc """
  Formats either a date or a datetime to ISO-8601.
  """
  @spec format_iso_date(Date.t() | DateTime.t()) :: String.t()
  def format_iso_date(date = %Date{}) do
    date
    |> DateTime.new!(~T[06:00:00])
    |> format_iso_date()
  end

  def format_iso_date(date = %DateTime{}), do: DateTime.to_iso8601(date)

  defp render(path, rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    write_file(path, safe)
  end

  defp render_rss(path, posts) do
    XmlBuilder.element(:rss, %{version: "2.0", "xmlns:atom": "http://www.w3.org/2005/Atom"}, [
      {:channel,
       [
         {:title, site_config(:site_title)},
         {:link, site_config(:site_url)},
         {:description, "Recent content on #{site_config(:site_title)}"},
         {:language, "en-us"},
         {:managingEditor, "#{site_config(:site_url)} (#{site_config(:site_email)})"},
         {:webMaster, "#{site_config(:site_author)} (#{site_config(:site_email)})"},
         {:copyright, site_config(:site_copyright)},
         {:lastBuildDate, format_rss_date(DateTime.utc_now())},
         {:"atom:link",
          %{
            href: "#{site_config(:site_url)}/index.xml",
            rel: "self",
            type: "application/rss+xml"
          }}
       ] ++
         for post <- Enum.take(posts, site_config(:rss_post_limit)) do
           {:item,
            [
              {:title, post.title},
              {:link, site_config(:site_url) <> post.route},
              {:pubDate, format_rss_date(post.date)},
              {:author, "#{site_config(:site_author)} (#{site_config(:site_email)})"},
              {:guid, site_config(:site_url) <> post.route},
              {:description, post.description}
            ]}
         end}
    ])
    |> XmlBuilder.generate()
    |> then(&write_file(path, &1))
  end

  defp format_rss_date(date = %DateTime{}) do
    Calendar.strftime(date, "%a, %d %b %Y %H:%M:%S %z")
  end

  defp format_rss_date(date = %Date{}) do
    date
    |> DateTime.new!(~T[06:00:00])
    |> format_rss_date()
  end

  defp write_file(path, data) do
    dir = Path.dirname(path)
    output = Path.join([site_config(:output_dir), path])

    if dir != "." do
      File.mkdir_p!(Path.join([site_config(:output_dir), dir]))
    end

    File.write!(output, data)
  end

  defp assert_uniq_page_ids!(pages) do
    ids = pages |> Enum.map(& &1.id)
    dups = Enum.uniq(ids -- Enum.uniq(ids))

    if dups |> Enum.empty?() do
      :ok
    else
      raise "Duplicate pages: #{inspect(dups)}"
    end
  end
end

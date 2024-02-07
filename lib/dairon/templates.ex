defmodule Dairon.Templates do
  use Phoenix.Component
  import Phoenix.HTML
  import Dairon, only: [site_config: 1]

  embed_templates("templates/*")

  def render(path, rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    write_file(path, safe)
  end

  def render_rss(path, posts) do
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

  def render_sitemap(path, pages) do
    {:urlset,
     %{
       xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9",
       "xmlns:xhtml": "http://www.w3.org/1999/xhtml"
     },
     [
       {:url, [{:loc, site_config(:site_url)}, {:lastmod, format_iso_date(DateTime.utc_now())}]}
       | for page <- pages do
           {:url,
            [
              {:loc, site_config(:site_url) <> page.route},
              {:lastmod, format_iso_date(page.date)}
            ]}
         end
     ]}
    |> XmlBuilder.document()
    |> XmlBuilder.generate()
    |> then(&write_file(path, &1))
  end

  def format_iso_date(date = %DateTime{}) do
    DateTime.to_iso8601(date)
  end

  def format_iso_date(date = %Date{}) do
    date
    |> DateTime.new!(~T[06:00:00])
    |> format_iso_date()
  end

  def format_post_date(date) do
    Calendar.strftime(date, "%B %-d, %Y")
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
end

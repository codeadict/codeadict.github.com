defmodule Dairon.Templates do
  use Phoenix.Component
  alias Dairon.Content
  import Phoenix.HTML

  embed_templates("templates/*")

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

  def format_rss_date(date = %DateTime{}) do
    Calendar.strftime(date, "%a, %d %b %Y %H:%M:%S %z")
  end

  def format_rss_date(date = %Date{}) do
    date
    |> DateTime.new!(~T[06:00:00])
    |> format_rss_date()
  end

  def rss_post_limit() do
    20
  end

  def count_words(text) do
    text
    |> HtmlSanitizeEx.strip_tags()
    |> String.split()
    |> Enum.count()
  end

  def rss(posts) do
    XmlBuilder.element(:rss, %{version: "2.0", "xmlns:atom": "http://www.w3.org/2005/Atom"}, [
      {:channel,
       [
         {:title, Content.site_config(:site_title)},
         {:link, Content.site_config(:site_url)},
         {:description, "Recent content on #{Content.site_config(:site_title)}"},
         {:language, "en-us"},
         {:managingEditor,
          "#{Content.site_config(:site_url)} (#{Content.site_config(:site_email)})"},
         {:webMaster,
          "#{Content.site_config(:site_author)} (#{Content.site_config(:site_email)})"},
         {:copyright, Content.site_config(:site_copyright)},
         {:lastBuildDate, format_rss_date(DateTime.utc_now())},
         {:"atom:link",
          %{
            href: "#{Content.site_config(:site_url)}/index.xml",
            rel: "self",
            type: "application/rss+xml"
          }}
       ] ++
         for post <- Enum.take(posts, rss_post_limit()) do
           {:item,
            [
              {:title, post.title},
              {:link, Content.site_config(:site_url) <> post.route},
              {:pubDate, format_rss_date(post.date)},
              {:author,
               "#{Content.site_config(:site_author)} (#{Content.site_config(:site_email)})"},
              {:guid, Content.site_config(:site_url) <> post.route},
              {:description, post.description}
            ]}
         end}
    ])
    |> XmlBuilder.generate()
  end

  def sitemap(pages) do
    {:urlset,
     %{
       xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9",
       "xmlns:xhtml": "http://www.w3.org/1999/xhtml"
     },
     [
       {:url,
        [{:loc, Content.site_config(:site_url)}, {:lastmod, format_iso_date(DateTime.utc_now())}]}
       | for page <- pages do
           {:url,
            [
              {:loc, Content.site_config(:site_url) <> page.route},
              {:lastmod, format_iso_date(page.date)}
            ]}
         end
     ]}
    |> XmlBuilder.document()
    |> XmlBuilder.generate()
  end
end

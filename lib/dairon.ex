defmodule Dairon do
  @moduledoc """
  All functionality for rendering and building the site
  """

  require Logger
  alias Dairon.Content
  alias Dairon.Templates

  def site_config(key) do
    Application.get_env(:dairon, key)
  end

  def build_pages() do
    pages = Content.all_pages()
    all_posts = Content.all_posts()
    about_page = Content.about_page()
    Content.assert_uniq_page_ids!(pages)
    Templates.render_file("index.html", Templates.index(%{posts: Content.all_posts()}))
    Templates.render_file("404.html", Templates.page(Content.not_found_page()))
    Templates.render_file(about_page.html_path, Templates.page(about_page))
    Templates.render_file("archive/index.html", Templates.archive(%{posts: all_posts}))
    Templates.write_file("feed.xml", Templates.rss(all_posts))
    # Templates.write_file("sitemap.xml", Templates.sitemap(pages))

    for post <- all_posts do
      Templates.render_file(post.html_path, Templates.post(post))
    end

    :ok
  end

  def build_all() do
    Logger.info("Clear output directory")
    File.rm_rf!(site_config(:output_dir))
    File.mkdir_p!(site_config(:output_dir))
    Logger.info("Copying static files")
    File.cp_r!("assets/static", site_config(:output_dir))
    Logger.info("Building pages...")
    {micro, :ok} = :timer.tc(fn -> build_pages() end)
    Logger.info("Pages built in #{micro / 1000}ms")
    Logger.info("Building CSS...")
    Mix.Tasks.Sass.run(["default", "--no-source-map", "--style=compressed"])
  end
end

defmodule Dairon do
  @moduledoc """
  All functionality for rendering and building the site
  """

  require Logger
  use Application

  alias Dairon.Content
  alias Dairon.Templates

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: Dairon.DevServer, scheme: :http, port: 3000}
    ]

    Logger.info("Development site serving at: http://localhost:3000")
    Supervisor.start_link(children, strategy: :one_for_one, name: Dairon.Supervisor)
  end

  def site_config(key) do
    Application.get_env(:dairon, key)
  end

  def build_pages() do
    pages = Content.all_pages()
    all_posts = Content.all_posts()
    about_page = Content.about_page()
    Content.assert_uniq_page_ids!(pages)
    Templates.render("index.html", Templates.index(%{posts: Content.all_posts()}))
    Templates.render("404.html", Templates.page(Content.not_found_page()))
    Templates.render(about_page.html_path, Templates.page(about_page))
    Templates.render("archive/index.html", Templates.archive(%{posts: all_posts}))
    Templates.render_rss("feed.xml", all_posts)
    Templates.render_sitemap("sitemap.xml", pages)

    for post <- all_posts do
      Templates.render(post.html_path, Templates.post(post))
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

defmodule Dairon do
  @moduledoc """
  All functionality for rendering and building the site
  """

  require Logger
  alias Dairon.Content
  alias Dairon.Templates

  @output_dir Application.compile_env!(:dairon, :output_dir)

  def assert_uniq_page_ids!(pages) do
    ids = pages |> Enum.map(& &1.id)
    dups = Enum.uniq(ids -- Enum.uniq(ids))

    if dups |> Enum.empty?() do
      :ok
    else
      raise "Duplicate pages: #{inspect(dups)}"
    end
  end

  def render_posts(posts) do
    for post <- posts do
      render_file(post.html_path, Templates.post(post))
    end
  end

  def build_pages() do
    pages = Content.all_pages()
    all_posts = Content.all_posts()
    about_page = Content.about_page()
    assert_uniq_page_ids!(pages)
    render_file("index.html", Templates.index(%{posts: Content.all_posts()}))
    render_file("404.html", Templates.page(Content.not_found_page()))
    render_file(about_page.html_path, Templates.page(about_page))
    render_file("archive/index.html", Templates.archive(%{posts: all_posts}))
    write_file("feed.xml", Templates.rss(all_posts))
    write_file("sitemap.xml", Templates.sitemap(pages))
    render_posts(all_posts)
    :ok
  end

  def write_file(path, data) do
    dir = Path.dirname(path)
    output = Path.join([@output_dir, path])

    if dir != "." do
      File.mkdir_p!(Path.join([@output_dir, dir]))
    end

    File.write!(output, data)
  end

  def render_file(path, rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    write_file(path, safe)
  end

  def build_all() do
    Logger.info("Clear output directory")
    File.rm_rf!(@output_dir)
    File.mkdir_p!(@output_dir)
    Logger.info("Copying static files")
    File.cp_r!("assets/static", @output_dir)
    Logger.info("Building pages...")

    {micro, :ok} =
      :timer.tc(fn ->
        build_pages()
      end)

    ms = micro / 1000
    Logger.info("Pages built in #{ms}ms")
    Logger.info("Building CSS...")
    Mix.Tasks.Sass.run(["default", "--no-source-map", "--style=compressed"])
  end
end

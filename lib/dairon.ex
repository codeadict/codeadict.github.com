defmodule Dairon do
  @moduledoc """
  Static page generator for my personal Website (https://www.dairon.org).
  """
  require Logger

  @doc """
  Return a configuration value from the site config.
  """
  @spec site_config(atom()) :: any()
  def site_config(key) do
    Application.get_env(:dairon, key)
  end

  @doc """
  Builds all the pages and assets.
  """
  @spec build() :: :ok
  def build do
    Logger.info("Clear output directory")
    File.rm_rf!(site_config(:output_dir))
    File.mkdir_p!(site_config(:output_dir))
    Logger.info("Copying static files")
    File.cp_r!("assets/static", site_config(:output_dir))
    File.cp!("robots.txt", "#{site_config(:output_dir)}/robots.txt")
    Logger.info("Building pages...")
    {micro, :ok} = :timer.tc(fn -> Dairon.Templates.render_all() end)
    Logger.info("Pages built in #{micro / 1000}ms")
    Logger.info("Building CSS...")
    Mix.Tasks.Sass.run(["default", "--no-source-map", "--style=compressed"])
  end
end

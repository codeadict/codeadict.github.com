defmodule Mix.Tasks.Dairon.Server do
  @moduledoc """
  Starts a simple local development server to preview the site.
  """
  require Logger
  use Mix.Task

  @shortdoc "Start the local development server"

  @impl true
  def run(_) do
    path = Path.join([File.cwd!(), Dairon.site_config(:output_dir)])

    Dairon.build()
    Application.ensure_all_started(:inets)

    case :inets.start(:httpd,
           server_name: ~c"dairon_local_server",
           document_root: to_charlist(path),
           directory_index: [to_charlist("index.html")],
           server_root: to_charlist("."),
           port: 0,
           mime_types: [
             {~c"html", ~c"text/html"},
             {~c"txt", ~c"text/plain"},
             {~c"xml", ~c"text/xml"},
             {~c"json", ~c"application/json"},
             {~c"js", ~c"application/x-javascript"},
             {~c"css", ~c"text/css"},
             {~c"gif", ~c"image/gif"},
             {~c"jpg", ~c"image/jpeg"},
             {~c"jpeg", ~c"image/jpeg"},
             {~c"png", ~c"image/png"},
             {~c"webp", ~c"image/webp"}
           ]
         ) do
      {:ok, pid} ->
        info = :httpd.info(pid)
        port = Keyword.get(info, :port)

        Logger.info("Development Server available at http://localhost:#{port}/")
        Process.sleep(:infinity)

      {:error, reason} ->
        Logger.error("Failed to start development server: #{reason}")
    end
  end
end

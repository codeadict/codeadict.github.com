defmodule Dairon.DevServer do
  @moduledoc """
  Local development server.
  """
  use Plug.Router

  @output_dir "site"

  Dairon.build_all()

  # Recompile all the time.
  def __mix_recompile__?, do: true

  plug(Plug.Logger, log: :info)
  plug(Plug.Static, at: "/", from: @output_dir)
  plug(:match)
  plug(:dispatch)

  get "/*path" do
    path = Path.join([File.cwd!(), @output_dir] ++ conn.path_info ++ ["index.html"])

    if File.exists?(path) do
      send_file(conn, 200, path)
    else
      path = Path.join([File.cwd!(), @output_dir, "404.html"])
      send_file(conn, 404, path)
    end
  end
end

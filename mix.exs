defmodule Dairon.MixProject do
  use Mix.Project

  def project do
    [
      app: :dairon,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Dairon, []}
    ]
  end

  defp deps do
    [
      {:nimble_publisher, "~> 1.1.0"},
      {:makeup_elixir, "~> 0.16.1"},
      {:makeup_js, "~> 0.1.0"},
      {:makeup_json, "~> 0.1.0"},
      {:makeup_html, "~> 0.1.1"},
      {:phoenix_live_view, "~> 0.20.3"},
      {:xml_builder, "~> 2.2.0"},
      {:yaml_elixir, "~> 2.9.0"},
      {:html_sanitize_ex, "~> 1.4.3"},
      {:dart_sass, "~> 0.6"},
      {:bandit, "~> 1.2.0"},
      {:exsync, "~> 0.2"}
    ]
  end
end

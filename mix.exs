defmodule Dairon.MixProject do
  use Mix.Project

  def project do
    [
      app: :dairon,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases do
    [
      compile: ["compile", &compile_site/1]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
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
      {:dart_sass, "~> 0.6"}
    ]
  end

  defp compile_site(_args) do
    Dairon.build()
  end
end

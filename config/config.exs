import Config

output_dir = "site"

author = "Dairon Medina Caro"
year = Date.utc_today().year

config :dairon,
  site_title: author,
  site_description: "Ideas, writtings, recipes, and software projects by #{author}.",
  site_url: "https://dairon.org",
  site_author: author,
  site_email: "me@dairon.org",
  site_copyright: "© #{year} #{author}",
  rss_post_limit: 20,
  output_dir: output_dir

config :dart_sass,
  version: "1.70.0",
  default: [
    args: [
      "app.scss",
      "../#{output_dir}/assets/app.css"
    ],
    cd: Path.expand("../assets", __DIR__)
  ]

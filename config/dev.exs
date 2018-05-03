use Mix.Config

config :namely, Namely.Repo, [
  adapter: Ecto.Adapters.Postgres,
  database: "namely_#{Mix.env}",
  username: "postgres",
  password: "",
  hostname: "localhost",
]
use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :brando_pages, BrandoPages.Integration.Endpoint,
  http: [port: 4001],
  server: false,
  secret_key_base: "verysecret"

config :logger, level: :warn

config :brando_pages, BrandoPages.Integration.TestRepo,
  url: "ecto://postgres:postgres@localhost/brando_pages_test",
  adapter: Ecto.Adapters.Postgres,
  extensions: [{Postgrex.Extensions.JSON, library: Poison}],
  pool: Ecto.Adapters.SQL.Sandbox,
  max_overflow: 0


config :brando, :router, BrandoPages.Router
config :brando, :endpoint, BrandoPages.Integration.Endpoint
config :brando, :repo, BrandoPages.Integration.TestRepo
config :brando, :helpers, BrandoPages.Router.Helpers

config :brando, Brando.Menu, [
  modules: [Brando.Pages.Menu],
  colors: ["#FBA026;", "#F87117;", "#CF3510;", "#890606;", "#FF1B79;",
           "#520E24;", "#8F2041;", "#DC554F;", "#FF905E;", "#FAC51C;",
           "#D6145F;", "#AA0D43;", "#7A0623;", "#430202;", "#500422;",
           "#870B46;", "#D0201A;", "#FF641A;"]]

config :brando, Brando.Villain, parser: Brando.Villain.Parser.Default
config :brando, Brando.Villain, extra_blocks: []

config :brando, :default_language, "nb"
config :brando, :admin_default_language, "nb"
config :brando, :languages, [
  [value: "nb", text: "Norsk"],
  [value: "en", text: "English"]
]
config :brando, :admin_languages, [
  [value: "nb", text: "Norsk"],
  [value: "en", text: "English"]
]

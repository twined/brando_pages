# Brando Pages

[![Coverage Status](https://coveralls.io/repos/github/twined/brando_pages/badge.svg?branch=master)](https://coveralls.io/github/twined/brando_pages?branch=master)

## Installation

Add brando_pages to your list of dependencies in `mix.exs`:

```diff
    def deps do
      [
        {:brando, github: "twined/brando"},
+       {:brando_pages, github: "twined/brando_pages"}
      ]
    end
```

Install migrations and frontend files:

    $ mix brando.pages.install

Run migrations

    $ mix ecto.migrate

Add to your `web/router.ex`:

```diff

    defmodule MyApp.Router do
      use MyApp.Web, :router
      # ...
+     import Brando.Pages.Routes.Admin

      scope "/admin", as: :admin do
        pipe_through :admin
        dashboard_routes   "/"
        user_routes        "/users"
+       page_routes        "/pages"
      end
    end
```

Add to your `config/brando.exs`:

```diff
    config :brando, Brando.Menu,
      colors: [...],
      modules: [
        Brando.Menu.Admin, 
        Brando.Menu.Users, 
+       Brando.Menu.Pages
      ]
```

Add to your `web/static/css/app.scss`:

```diff
  @import
    "includes/colorbox",
    "includes/cookielaw",
    "includes/dropdown",
    "includes/instagram",
-   "includes/nav";
+   "includes/nav",
+   "includes/pages";

```
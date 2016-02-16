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

Add to your `lib/my_app.ex`:

```diff
    def start(_type, _args) do
      import Supervisor.Spec, warn: false

      children = [
        # Start the endpoint when the application starts
        supervisor(MyApp.Endpoint, []),
        # Start the Ecto repository
        supervisor(MyApp.Repo, []),
        # Here you could define other workers and supervisors as children
        # worker(MyApp.Worker, [arg1, arg2, arg3]),
      ]

+     Brando.Registry.register(Brando.Pages)
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
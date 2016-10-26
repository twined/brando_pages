defmodule Brando.Pages.Routes.Admin do
  @moduledoc """
  Routes for Brando.Pages

  ## Usage:

  In `router.ex`

      scope "/admin", as: :admin do
        pipe_through :admin
        page_routes "/pages"

  """
  alias Brando.Admin.PageController
  alias Brando.Admin.PageFragmentController
  import Brando.Villain.Routes.Admin

  @doc """
  Defines "RESTful" endpoints for the pages resource.
  """
  defmacro page_routes(path), do:
    add_page_routes(path, PageController, [])

  defp add_page_routes(path, controller, opts) do
    quote do
      path = unquote(path)
      ctrl = unquote(controller)
      opts = unquote(opts)
      nil_opts = Keyword.put(opts, :as, nil)
      fctrl = PageFragmentController

      villain_routes "#{path}/fragments", fctrl

      get    "#{path}/fragments",            fctrl, :index,          opts
      get    "#{path}/fragments/new",        fctrl, :new,            opts
      get    "#{path}/fragments/:id",        fctrl, :show,           opts
      get    "#{path}/fragments/:id/edit",   fctrl, :edit,           opts
      get    "#{path}/fragments/:id/delete", fctrl, :delete_confirm, opts
      post   "#{path}/fragments",            fctrl, :create,         opts
      delete "#{path}/fragments/:id",        fctrl, :delete,         opts
      patch  "#{path}/fragments/:id",        fctrl, :update,         opts
      put    "#{path}/fragments/:id",        fctrl, :update,         nil_opts

      villain_routes path, ctrl

      get    "#{path}",               ctrl, :index,          opts
      get    "#{path}/new",           ctrl, :new,            opts
      get    "#{path}/rerender",      ctrl, :rerender,       opts
      get    "#{path}/:id",           ctrl, :show,           opts
      get    "#{path}/:id/duplicate", ctrl, :duplicate,      opts
      get    "#{path}/:id/edit",      ctrl, :edit,           opts
      get    "#{path}/:id/delete",    ctrl, :delete_confirm, opts
      post   "#{path}",               ctrl, :create,         opts
      delete "#{path}/:id",           ctrl, :delete,         opts
      patch  "#{path}/:id",           ctrl, :update,         opts
      put    "#{path}/:id",           ctrl, :update,         nil_opts
    end
  end
end

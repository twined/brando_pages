defmodule BrandoPages.RoutesTest do
  use ExUnit.Case

  setup do
    routes =
      Phoenix.Router.ConsoleFormatter.format(Brando.router)
    {:ok, [routes: routes]}
  end

  test "news_resources", %{routes: routes} do
    assert routes =~ "/admin/pages/new"
    assert routes =~ "/admin/pages/:id/edit"
  end
end
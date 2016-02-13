defmodule Brando.Pages.PageTest do
  use ExUnit.Case
  use BrandoPages.ConnCase
  alias Brando.Page
  alias BrandoPages.Factory

  setup do
    user = Factory.create(:user)
    page = Factory.create(:page, creator: user)
    {:ok, %{user: user, page: page}}
  end

  test "search" do
    results = Brando.repo.all(Page.search("en", "text"))
    assert length(results) == 1
    p = List.first(results)
    assert p.title == "Page title"
  end

  test "meta", %{page: page} do
    assert Brando.Page.__name__(:singular) == "page"
    assert Brando.Page.__name__(:plural) == "pages"
    assert Brando.Page.__repr__(page) == "Page title"
  end
end

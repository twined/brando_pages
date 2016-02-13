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
    assert Page.__name__(:singular) == "page"
    assert Page.__name__(:plural) == "pages"
    assert Page.__repr__(page) == "Page title"
  end

  test "encode_data" do
    assert Page.encode_data(%{data: "test"}) == %{data: "test"}
    assert Page.encode_data(%{data: [%{key: "value"}, %{key2: "value2"}]})
           == %{data: ~s([{"key":"value"},{"key2":"value2"}])}
  end
end

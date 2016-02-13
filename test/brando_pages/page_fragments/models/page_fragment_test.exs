defmodule Brando.Pages.PageFragmentTest do
  use ExUnit.Case
  use BrandoPages.ConnCase

  alias BrandoPages.Factory

  setup do
    user = Factory.create(:user)
    page = Factory.create(:page_fragment, creator: user)
    {:ok, %{user: user, page: page}}
  end

  test "meta", %{page: page} do
    assert Brando.PageFragment.__name__(:singular) == "page fragment"
    assert Brando.PageFragment.__name__(:plural) == "page fragments"
    assert Brando.PageFragment.__repr__(page) == "key/path"
  end

  test "encode data" do
    assert Brando.PageFragment.encode_data(%{data: "test"})
           == %{data: "test"}
    assert Brando.PageFragment.encode_data(%{data: [%{data: "test"}]})
           == %{data: ~s([{"data":"test"}])}
  end
end

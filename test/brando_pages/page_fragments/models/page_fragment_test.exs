defmodule Brando.Pages.PageFragmentTest do
  use ExUnit.Case
  use BrandoPages.ConnCase

  alias BrandoPages.Factory
  alias Brando.Pages.PageFragment

  setup do
    user = Factory.insert(:user)
    page = Factory.insert(:page_fragment, creator: user)
    {:ok, %{user: user, page: page}}
  end

  test "meta", %{page: page} do
    assert PageFragment.__name__(:singular) == "page fragment"
    assert PageFragment.__name__(:plural) == "page fragments"
    assert PageFragment.__repr__(page) == "key/path"
  end

  test "encode data" do
    assert PageFragment.encode_data(%{data: "test"})
           == %{data: "test"}
    assert PageFragment.encode_data(%{data: [%{data: "test"}]})
           == %{data: ~s([{"data":"test"}])}
  end
end

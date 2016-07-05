defmodule Brando.Pages.UtilsTest do
  use ExUnit.Case
  use BrandoPages.ConnCase
  use Plug.Test
  use RouterHelper

  alias BrandoPages.Factory
  alias Brando.Pages.Utils

  test "render_fragment invalid" do
    {:safe, return} = Utils.render_fragment("invalid/key")
    assert return =~ "Missing page fragment"
    assert return =~ "invalid/key"
    assert return =~ Brando.config(:default_language)
  end

  test "render_fragment valid" do
    user = Factory.insert(:user)
    Factory.insert(:page_fragment, creator: user)

    {:safe, return} = Utils.render_fragment("key/path")
    assert return =~ "Missing page fragment"

    {:safe, return} = Utils.render_fragment("key/path", "en")
    assert return =~ "<p>Text in p.</p>"
  end

end

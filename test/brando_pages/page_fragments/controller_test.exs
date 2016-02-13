defmodule Brando.PageFragments.ControllerTest do
  use ExUnit.Case
  use BrandoPages.ConnCase
  use Plug.Test
  use RouterHelper

  alias BrandoPages.Factory

  test "index" do
    conn =
      :get
      |> call("/admin/pages/fragments")
      |> with_user
      |> send_request

    assert response_content_type(conn, :html) =~ "charset=utf-8"
    assert html_response(conn, 200) =~ "Index - page fragments"
  end

  test "show" do
    user = Factory.create(:user)
    page = Factory.create(:page_fragment, creator: user)

    conn =
      :get
      |> call("/admin/pages/fragments/#{page.id}")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Text in p."
  end

  test "new" do
    conn =
      :get
      |> call("/admin/pages/fragments/new")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "New page fragment"
  end

  test "edit" do
    user = Factory.create(:user)
    page = Factory.create(:page_fragment, creator: user)

    conn =
      :get
      |> call("/admin/pages/fragments/#{page.id}/edit")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Edit page fragment"

    assert_raise Plug.Conn.WrapperError, fn ->
      :get
      |> call("/admin/pages/fragments/1234/edit")
      |> with_user
      |> send_request
    end
  end

  test "create (page) w/params" do
    user = Factory.create(:user)
    page_params = Factory.build(:page_fragment_params, creator: user)
    conn =
      :post
      |> call("/admin/pages/fragments/",
              %{"page_fragment" => page_params})
      |> with_user(user)
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/pages/fragments"
  end

  test "create (page) w/erroneus params" do
    user = Factory.create(:user)
    page_params =
      :page_fragment_params
      |> Factory.build(creator: user)
      |> Map.put("data", "")
    conn =
      :post
      |> call("/admin/pages/fragments/", %{"page_fragment" => page_params})
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "New page fragment"
    assert get_flash(conn, :error) == "Errors in form"
  end

  test "update (page) w/params" do
    user = Factory.create(:user)
    page = Factory.create(:page_fragment, creator: user)

    page_params =
      :page_fragment_params
      |> Factory.build(creator: user)
      |> Map.put("data", ~s([{"type":"text","data":{"text":"zcxvxcv","type":"paragraph"}}]))

    conn =
      :patch
      |> call("/admin/pages/fragments/#{page.id}", %{"page_fragment" => page_params})
      |> with_user(user)
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/pages/fragments"
  end

  test "update (page) w/erroneus params" do
    user = Factory.create(:user)
    page_fragment = Factory.create(:page_fragment, creator: user)

    page_fragment_params =
      :page_fragment_params
      |> Factory.build(creator: user)
      |> Map.put(:data, "")
      |> Map.put(:key, "")

    conn =
      :patch
      |> call("/admin/pages/fragments/#{page_fragment.id}", %{"page_fragment" => page_fragment_params})
      |> with_user(user)
      |> send_request

    assert html_response(conn, 200) =~ "Edit page fragment"
    assert get_flash(conn, :error) == "Errors in form"
  end

  test "delete_confirm" do
    user = Factory.create(:user)
    page = Factory.create(:page_fragment, creator: user)

    conn =
      :get
      |> call("/admin/pages/fragments/#{page.id}/delete")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Delete page fragment: key/path"
  end

  test "delete" do
    user = Factory.create(:user)
    page = Factory.create(:page_fragment, creator: user)

    conn =
      :delete
      |> call("/admin/pages/fragments/#{page.id}")
      |> with_user
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/pages/fragments"
  end

  test "uses villain" do
    funcs =
      :functions
      |> Brando.Admin.PageFragmentController.__info__
      |> Keyword.keys

    assert :browse_images in funcs
    assert :upload_image in funcs
    assert :image_info in funcs
    assert :imageseries in funcs
  end
end

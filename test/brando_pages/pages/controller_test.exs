defmodule Brando.Pages.ControllerTest do
  use ExUnit.Case
  use BrandoPages.ConnCase
  use Plug.Test
  use RouterHelper

  alias BrandoPages.Factory

  test "index" do
    conn =
      :get
      |> call("/admin/pages")
      |> with_user
      |> send_request

    assert response_content_type(conn, :html) =~ "charset=utf-8"
    assert html_response(conn, 200) =~ "Index - pages"
  end

  test "show" do
    user = Factory.insert(:user)
    page = Factory.insert(:page, creator: user)

    conn =
      :get
      |> call("/admin/pages/#{page.id}")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Text in p."
  end

  test "new" do
    conn =
      :get
      |> call("/admin/pages/new")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "New page"
  end

  test "edit" do
    user = Factory.insert(:user)
    page = Factory.insert(:page, creator: user)

    conn =
      :get
      |> call("/admin/pages/#{page.id}/edit")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Edit page"

    assert_raise Plug.Conn.WrapperError, fn ->
      :get
      |> call("/admin/pages/1234/edit")
      |> with_user
      |> send_request
    end
  end

  test "create (page) w/params" do
    user = Factory.insert(:user)
    page_params = Factory.params_for(:page, creator_id: user.id)
    conn =
      :post
      |> call("/admin/pages/", %{"page" => page_params})
      |> with_user(user)
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/pages"
  end

  test "create (page) w/erroneus params" do
    user = Factory.insert(:user)
    page_params =
      Factory.params_for(:page, creator: user, data: "")
    conn =
      :post
      |> call("/admin/pages/", %{"page" => page_params})
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "New page"
    assert get_flash(conn, :error) == "Errors in form"
  end

  test "update (page) w/params" do
    user = Factory.insert(:user)
    page = Factory.insert(:page, creator: user)

    page_params =
      Factory.params_for(:page, creator_id: user.id, data: ~s([{"type":"text","data":{"text":"zcxvxcv","type":"paragraph"}}]))

    conn =
      :patch
      |> call("/admin/pages/#{page.id}", %{"page" => page_params})
      |> with_user(user)
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/pages"
  end

  test "update (page) w/erroneus params" do
    user = Factory.insert(:user)
    page = Factory.insert(:page, creator: user)

    page_params =
      :page
      |> Factory.params_for(creator_id: user.id)
      |> Map.put(:title, "")
      |> Map.put(:data, ~s([{"type":"text","data":{"text":"zcxvxcv","type":"paragraph"}}]))

    conn =
      :patch
      |> call("/admin/pages/#{page.id}", %{"page" => page_params})
      |> with_user(user)
      |> send_request

    assert html_response(conn, 200) =~ "Edit page"
    assert get_flash(conn, :error) == "Errors in form"
  end

  test "delete_confirm" do
    user = Factory.insert(:user)
    page = Factory.insert(:page, creator: user)

    conn =
      :get
      |> call("/admin/pages/#{page.id}/delete")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Delete page: Page title"
  end

  test "delete" do
    user = Factory.insert(:user)
    page = Factory.insert(:page, creator: user)

    conn =
      :delete
      |> call("/admin/pages/#{page.id}")
      |> with_user
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/pages"
  end

  test "rerender" do
    user = Factory.insert(:user)
    Factory.insert(:page, creator: user)

    conn =
      :get
      |> call("/admin/pages/rerender")
      |> with_user
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/pages"
    assert get_flash(conn, :notice) == "Pages re-rendered"
  end

  test "duplicate" do
    user = Factory.insert(:user)
    page = Factory.insert(:page, creator: user)

    conn =
      :get
      |> call("/admin/pages/#{page.id}/duplicate")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "New page"
    assert get_flash(conn, :notice) == "Page duplicated"
  end

  test "uses villain" do
    funcs = Brando.Admin.PageController.__info__(:functions)
    funcs = Keyword.keys(funcs)

    assert :browse_images in funcs
    assert :upload_image in funcs
    assert :image_info in funcs
  end
end

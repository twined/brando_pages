defmodule Brando.Admin.PageController do
  @moduledoc """
  Controller for the Brando Pages module.
  """

  use Brando.Web, :controller
  use Brando.Villain, :controller
  import Brando.Pages.Gettext
  import Brando.Plug.HTML
  import Brando.Utils, only: [helpers: 1]
  import Brando.Utils.Schema, only: [put_creator: 2]

  alias Brando.Pages.Page

  plug :put_section, "pages"
  plug :scrub_params, "page" when action in [:create, :update]

  @doc false
  def index(conn, _params) do
    pages =
      Page
      |> Page.with_parents_and_children
      |> Page.order
      |> Brando.repo.all

    conn
    |> assign(:page_title, gettext("Index - pages"))
    |> assign(:pages, pages)
    |> render(:index)
  end

  @doc false
  def rerender(conn, _params) do
    pages = Brando.repo.all(Page)

    for page <- pages do
      Page.rerender_html(Page.changeset(page, :update, %{}))
    end

    conn
    |> put_flash(:notice, gettext("Pages re-rendered"))
    |> redirect(to: helpers(conn).admin_page_path(conn, :index))
  end

  @doc false
  def show(conn, %{"id" => id}) do
    page =
      Page
      |> Page.with_children
      |> Brando.repo.get_by(id: id)

    conn
    |> assign(:page_title, gettext("Show page"))
    |> assign(:page, page)
    |> render(:show)
  end

  @doc false
  def new(conn, _params) do
    changeset = Page.changeset(%Page{}, :create)

    conn
    |> assign(:changeset, changeset)
    |> assign(:page_title, gettext("New page"))
    |> render(:new)
  end

  @doc false
  def create(conn, %{"page" => page}) do
    changeset =
      %Page{}
      |> put_creator(Brando.Utils.current_user(conn))
      |> Page.changeset(:create, page)

    case Brando.repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:notice, gettext("Page created"))
        |> redirect(to: helpers(conn).admin_page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, gettext("Errors in form"))
        |> assign(:page_title, gettext("New page"))
        |> assign(:page, page)
        |> assign(:changeset, changeset)
        |> render(:new)
    end
  end

  @doc false
  def duplicate(conn, %{"id" => id}) do
    page =
      Page
      |> Brando.repo.get_by(id: id)
      |> Map.drop([:id, :children, :creator, :parent, :updated_at, :inserted_at])

    changeset = Page.changeset(page, :create)

    conn
    |> put_flash(:notice, gettext("Page duplicated"))
    |> assign(:page_title, gettext("New page"))
    |> assign(:page, page)
    |> assign(:changeset, changeset)
    |> render(:new)
  end

  @doc false
  def edit(conn, %{"id" => id}) do
    changeset =
      Page
      |> Brando.repo.get!(id)
      |> Page.encode_data
      |> Page.changeset(:update)

      conn
      |> assign(:page_title, gettext("Edit page"))
      |> assign(:changeset, changeset)
      |> assign(:id, id)
      |> render(:edit)
  end

  @doc false
  def update(conn, %{"page" => page, "id" => id}) do
    changeset =
      Page
      |> Brando.repo.get_by!(id: id)
      |> Page.changeset(:update, page)

    case Brando.repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:notice, gettext("Page updated"))
        |> redirect(to: helpers(conn).admin_page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:page_title, gettext("Edit page"))
        |> assign(:page, page)
        |> assign(:changeset, changeset)
        |> assign(:id, id)
        |> put_flash(:error, gettext("Errors in form"))
        |> render(:edit)
    end
  end

  @doc false
  def delete_confirm(conn, %{"id" => id}) do
    record =
      Page
      |> Page.with_children
      |> Brando.repo.get_by(id: id)

    conn
    |> assign(:page_title, gettext("Confirm deletion"))
    |> assign(:record, record)
    |> render(:delete_confirm)
  end

  @doc false
  def delete(conn, %{"id" => id}) do
    Page
    |> Brando.repo.get(id)
    |> Brando.repo.delete

    conn
    |> put_flash(:notice, gettext("Page deleted"))
    |> redirect(to: helpers(conn).admin_page_path(conn, :index))
  end
end

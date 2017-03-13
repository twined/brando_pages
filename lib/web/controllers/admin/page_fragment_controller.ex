defmodule Brando.Admin.PageFragmentController do
  @moduledoc """
  Controller for the Brando PageFragment module.
  """
  use Brando.Web, :controller
  use Brando.Villain, :controller

  import Ecto.Query

  import Brando.Pages.Gettext
  import Brando.Plug.HTML
  import Brando.Utils, only: [helpers: 1]
  import Brando.Utils.Schema, only: [put_creator: 2]

  alias Brando.Pages.PageFragment

  plug :put_section, "page_fragments"
  plug :scrub_params, "page_fragment" when action in [:create, :update]

  @doc false
  def index(conn, _params) do
    page_fragments = Brando.repo.all(
      from pf in PageFragment,
        order_by: [desc: pf.inserted_at],
        preload: [:creator]
    )

    conn
    |> assign(:page_fragments, page_fragments)
    |> assign(:page_title, gettext("Index - page fragments"))
    |> render(:index)
  end

  @doc false
  def show(conn, %{"id" => id}) do
    page =
      PageFragment
      |> preload(:creator)
      |> Brando.repo.get_by!(id: id)

    conn
    |> assign(:page_fragment, page)
    |> assign(:page_title, gettext("Show page fragment"))
    |> render(:show)
  end

  @doc false
  def new(conn, _params) do
    changeset = PageFragment.changeset(%PageFragment{}, :create)

    conn
    |> assign(:changeset, changeset)
    |> assign(:page_title, gettext("New page fragment"))
    |> render(:new)
  end

  @doc false
  def create(conn, %{"page_fragment" => page_fragment}) do
    changeset =
      %PageFragment{}
      |> put_creator(Brando.Utils.current_user(conn))
      |> PageFragment.changeset(:create, page_fragment)

    case Brando.repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:notice, gettext("Page fragment created"))
        |> redirect(to: helpers(conn).admin_page_fragment_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:page_title, gettext("New page fragment"))
        |> assign(:page_fragment, page_fragment)
        |> assign(:changeset, changeset)
        |> put_flash(:error, gettext("Errors in form"))
        |> render(:new)
    end
  end

  @doc false
  def edit(conn, %{"id" => id}) do
    changeset =
      PageFragment
      |> Brando.repo.get_by!(id: id)
      |> PageFragment.encode_data
      |> PageFragment.changeset(:update)

    conn
    |> assign(:page_title, gettext("Edit page fragment"))
    |> assign(:changeset, changeset)
    |> assign(:id, id)
    |> render(:edit)

  end

  @doc false
  def update(conn, %{"page_fragment" => page_fragment, "id" => id}) do
    changeset =
      PageFragment
      |> Brando.repo.get_by!(id: id)
      |> PageFragment.changeset(:update, page_fragment)

    case Brando.repo.update(changeset) do
      {:ok, _updated_page_fragment} ->
        conn
        |> put_flash(:notice, gettext("Page fragment updated"))
        |> redirect(to: helpers(conn).admin_page_fragment_path(conn, :index))

      {:error, changeset} ->
        conn
        |> assign(:page_title, gettext("Edit page fragment"))
        |> assign(:page_fragment, page_fragment)
        |> assign(:changeset, changeset)
        |> assign(:id, id)
        |> put_flash(:error, gettext("Errors in form"))
        |> render(:edit)
    end
  end

  @doc false
  def delete_confirm(conn, %{"id" => id}) do
    record =
      PageFragment
      |> preload(:creator)
      |> Brando.repo.get_by!(id: id)

    conn
    |> assign(:page_title, gettext("Confirm deletion"))
    |> assign(:record, record)
    |> render(:delete_confirm)
  end

  @doc false
  def delete(conn, %{"id" => id}) do
    PageFragment
    |> Brando.repo.get(id)
    |> Brando.repo.delete

    conn
    |> put_flash(:notice, gettext("Page fragment deleted"))
    |> redirect(to: helpers(conn).admin_page_fragment_path(conn, :index))
  end
end

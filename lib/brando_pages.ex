defmodule Brando.Pages do
  @moduledoc """
  Context for Brando.Pages
  """
  alias Brando.Pages.Page

  def get_page(key) do
    page = Brando.repo.get_by(Page, key: key)

    case page do
      nil  -> {:error, {:page, :not_found}}
      page -> {:ok, page}
    end
  end
end

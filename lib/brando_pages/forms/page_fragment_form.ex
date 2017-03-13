defmodule Brando.PageFragmentForm do
  @moduledoc """
  A form for the PageFragment schema. See the `Brando.Form` module for more
  documentation
  """

  use Brando.Form
  alias Brando.Pages.PageFragment

  @doc false
  def get_language_choices() do
    Brando.config(:languages)
  end

  form "page_fragment", [schema: PageFragment, class: "grid-form",
                         helper: :admin_page_fragment_path] do
    field :key, :text
    fieldset do
      field :language, :select, [default: "nb", choices: &__MODULE__.get_language_choices/0]
    end
    field :data, :textarea, [required: false]
    submit :save, [class: "btn btn-success"]
  end
end

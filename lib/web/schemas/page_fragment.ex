defmodule Brando.PageFragment do
  @moduledoc """
  Ecto schema for the PageFragment schema.
  """

  @type t :: %__MODULE__{}

  use Brando.Web, :schema
  use Brando.Villain, :schema

  alias Brando.Type.Json

  import Brando.Pages.Gettext

  @required_fields ~w(key language data creator_id)a
  @optional_fields ~w(html)a

  schema "pagefragments" do
    field :key, :string
    field :language, :string
    field :data, Json
    field :html, :string
    belongs_to :creator, Brando.User
    timestamps
  end

  @doc """
  Casts and validates `params` against `schema` to create a valid
  changeset when action is :create.

  ## Example

      schema_changeset = changeset(%__MODULE__{}, :create, params)

  """
  @spec changeset(t, atom, Keyword.t | Options.t) :: t
  def changeset(schema, action, params \\ %{})
  def changeset(schema, :create, params) do
    schema
    |> cast(params, @required_fields, @optional_fields)
    |> generate_html()
  end

  @doc """
  Casts and validates `params` against `schema` to create a valid
  changeset when action is :update.

  ## Example

      schema_changeset = changeset(%__MODULE__{}, :update, params)

  """
  @spec changeset(t, atom, Keyword.t | Options.t) :: t
  def changeset(schema, :update, params) do
    schema
    |> cast(params, @required_fields, @optional_fields)
    |> generate_html()
  end

  def encode_data(params) do
    if is_list(params.data) do
      Map.put(params, :data, Poison.encode!(params.data))
    else
      params
    end
  end

  #
  # Meta

  use Brando.Meta.Schema, [
    singular: gettext("page fragment"),
    plural: gettext("page fragments"),
    repr: &("#{&1.key}"),
    fields: [
      id: "№",
      language: gettext("Language"),
      key: gettext("Key"),
      data: gettext("Data"),
      html: gettext("HTML"),
      creator: gettext("Creator"),
      inserted_at: gettext("Inserted"),
      updated_at: gettext("Updated")
    ]
  ]
end
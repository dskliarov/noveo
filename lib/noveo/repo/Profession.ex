defmodule Noveo.Repo.Profession do

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}
  @required_fields ~w[name category_name]a

  @primary_key {:id, :integer, autogenerate: false}

  schema "professions" do
    field :name,          :string
    field :category_name, :string

    timestamps()
  end

  def changeset(params),
    do: %__MODULE__{} |> changeset(params)

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end

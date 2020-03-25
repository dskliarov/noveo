defmodule Noveo.Repo.JobPosting do

  use Ecto.Schema

  import Ecto.Changeset

  alias Noveo.Repo.Profession

  @type t() :: %__MODULE__{}
  @required_fields ~w[contract_type name profession_id]a
  @optional_fields ~w[office_latitude office_longitude geom sub_region]a

  @primary_key {:id, :integer, autogenerate: false}
  @foreign_key_type :integer

  schema "job_postings" do
    field :contract_type,   :string
    field :name,            :string
    field :sub_region,      :string
    field :office_latitude, :decimal
    field :office_longitude,:decimal
    field :geom,             Geo.PostGIS.Geometry

    belongs_to :profession,  Profession, primary_key: true

    timestamps()
  end

  def changeset(params), do: %__MODULE__{} |> changeset(params)

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

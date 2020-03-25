defmodule Noveo.Repo.Db do

  alias Noveo.Repo
  alias Repo.{Profession, JobPosting}

  def sanitize_float(strvalue) do
    case Float.parse(strvalue) do
      :error ->
        0.0
      {value, _} ->
        Float.round(value, 5)
    end
  end

  def sanitize_integer(strvalue) do
    case Integer.parse(strvalue) do
      :error ->
        0
      {value, _} ->
        value
    end
  end

  def insert_profession(%{"name" => name,
                          "category_name" => category_name,
                          "id" => id}) do
    %{id: id,
      name: name,
      category_name: category_name}
    |> Profession.changeset()
    |> Repo.insert
  end

  def insert_job_posting(%{"profession_id" => profession_id,
                           "contract_type" => contract_type,
                           "name" => name,
                           "office_latitude" => latitude,
                           "office_longitude" => longitude}) do
    latitude = sanitize_float(latitude)
    longitude = sanitize_float(longitude)
    {:ok, subregion} = Noveo.Geo.geo_to_subregion({latitude, longitude})

    %{profession_id: profession_id,
      contract_type: contract_type,
      name: name,
      sub_region: subregion,
      office_latitude: latitude,
      office_longitude: longitude,
      geom: %Geo.Point{
        coordinates: {latitude, longitude},
        srid: 4326
      }}
      |> JobPosting.changeset()
      |> Repo.insert
  end

  def tst(radius) do
    find_job_postings({2.3495396, 48.8676305}, radius, %{})
  end

  def find_job_postings(location, radius, _options) do
    location
    |> build_point()
    |> build_query(radius)
    |> Repo.all()
  end

  defp build_point({longitude, latitude}) do
    %Geo.Point{
      coordinates: {latitude, longitude},
      srid: 4326
    }
  end

  defp build_query(center, radius) do
    import Ecto.Query
    from j in JobPosting,
      join: f in assoc(j, :profession),
      select: %{contract_type: j.contract_type,
                name:                j.name,
                sub_region:          j.sub_region,
                office_latitude:     j.office_latitude,
                office_longitude:    j.office_longitude,
                profession_catogory: f.category_name,
                profession_name:     f.name},
      where:
      fragment(
        "ST_DWithin(geom::geography, ?, ?)",
        ^center,
        ^radius
      )
  end

end

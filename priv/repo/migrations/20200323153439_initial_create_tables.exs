defmodule Noveo.Repo.Migrations.InitialCreateTables do
  use Ecto.Migration

  def up do

    create table(:professions) do
      add :name,          :string
      add :category_name, :string
      add :inserted_at,   :naive_datetime, default: fragment("now()")
      add :updated_at,   :naive_datetime, default: fragment("now()")
    end

    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:job_postings) do
      add :contract_type,    :string
      add :name,             :string
      add :sub_region,       :string
      add :profession_id,    :bigint
      add :office_latitude,  :decimal, precision: 11, scale: 7
      add :office_longitude, :decimal, precision: 11, scale: 7
      add :geom,             :geometry
      add :inserted_at,      :naive_datetime, default: fragment("now()")
      add :updated_at,   :naive_datetime, default: fragment("now()")
    end

    execute "CREATE INDEX idx_job_postings_geom ON job_postings using GIST(geom)"
  end

  def down do
    execute "DROP INDEX idx_job_postings_geom;"
    drop table(:job_postings)
    drop table(:professions)
    execute "DROP EXTENSION IF EXISTS postgis"
  end
end

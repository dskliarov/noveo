defmodule Noveo.Lookup do
  alias Noveo.Utility

  @country :country_info
  @subregion :sub_region
  @profession :profession
  @country_file Application.get_env(:noveo, __MODULE__)[:country_info_file]
  @professions_file Application.get_env(:noveo, __MODULE__)[:professions_file]

  def get_continent(country_code) do
    @country
    |> get_value(country_code)
  end

  def get_subregion(country_code) do
    @subregion
    |> get_value(country_code)
  end

  def get_profession_category(profession_id) do
    @profession
    |> get_value(profession_id)
  end

  def preload() do
    preload_country_info()
    preload_subregion_info()
    preload_professions()
  end

  defp get_value(_prefix, nil), do: {:ok, ""}
  defp get_value(prefix, id) do
    {
      :ok,
     {prefix, String.upcase(id)}
     |> :persistent_term.get("Other")
    }
  end

  defp preload_country_info() do
    %{
      path: @country_file,
      key_field: "alpha-2",
      value_field: "region",
      prefix: @country
    }
    |> preload_lookup()
  end

  defp preload_subregion_info() do
    %{
      path: @country_file,
      key_field: "alpha-2",
      value_field: "sub-region",
      prefix: @subregion
    }
    |> preload_lookup()
  end

  defp preload_professions() do
    %{
      path: @professions_file,
      key_field: "id",
      value_field: "category_name",
      prefix: @profession
    }
    |> preload_lookup()
  end

  defp preload_lookup(%{path: path} = options) do
    path
    |> Utility.read_file()
    |> Stream.each(&kv_put(&1, options))
    |> Stream.run()
  end

  defp kv_put(map, %{key_field: key_field,
                     value_field: value_field,
                     prefix: prefix}) do
    key = Map.get(map, key_field)
    value = Map.get(map, value_field)
    :persistent_term.put({prefix, key}, value)
  end


end

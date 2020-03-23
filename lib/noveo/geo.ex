defmodule Noveo.Geo do

  alias Geocoder.Coords
  alias Geocoder.Location
  alias Noveo.Lookup

  def tst() do
    geo_to_continent({48.1392154, 11.5781413})
  end

  def geo_to_continent(geo) do
    with {:ok, country_code} <- geo_to_country_code(geo),
         {:ok, continent} <- Lookup.get_continent(country_code) do
      {:ok, continent}
    end
  end

  def geo_to_country_code({latitude, longitude}) do
    with {:ok, resp} <- Geocoder.call({latitude, longitude}) do
      {:ok, get_country_code(resp)}
    end
  end

  defp get_country_code(%Coords{
        location: %Location{
          country_code: country
        }}), do: country

end

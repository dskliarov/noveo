defmodule Noveo.ContinentsGrouping do

  alias Noveo.{Geo, Lookup, Utility}

  @jobs_file Application.get_env(:noveo, __MODULE__)[:jobs_file]
  @not_set {:ok, "Not Set"}
  @start_time :continents_grouping_start_time

  def run() do
    timer_start()

    @jobs_file
    |> Utility.read_file(read_ahead: 300)
    |> Flow.from_enumerable()
    |> Flow.map(&transform/1)
    |> Flow.partition()
    |> Flow.reduce(&init_reporter/0, &update_reporter/2)
    |> Flow.departition(&init_reporter/0, &merge_reporter/2, &report_result/1)
    |> Flow.run

    %{"execution time" => execution_time()}
    |> Scribe.print()
  end

  defp init_reporter() do
    {MapSet.new(), MapSet.new(), %{}}
  end

  defp report_result({continents, categories, cntr}) do
    continents
    |> Enum.reduce([], fn continent, acc ->
      [categories
      |> Enum.reduce(%{" Continent" => continent}, fn category, acc1 ->
        value = Map.get(cntr, {continent, category}, 0)
        Map.put(acc1, category, value)
      end) | acc]
    end) |> Scribe.print()
  end

  defp merge_reporter(
    {continents, categories, cntr},
    {continents_acc, categories_acc, cntr_acc}) do
    continents_acc1 = MapSet.union(continents, continents_acc)
    categories_acc1 = MapSet.union(categories, categories_acc)
    cntr_acc1 = Map.merge(cntr, cntr_acc)
    {continents_acc1, categories_acc1, cntr_acc1}
  end

  defp update_reporter(_value, nil), do: init_reporter()
  defp update_reporter({continent, category}, {continents, categories, acc}) do
    continents1 = MapSet.put(continents, continent)
    categories1 = MapSet.put(categories, category)
    acc = Map.update(acc, {continent, category}, 1, &(&1 + 1))
    {continents1, categories1, acc}
  end

  defp transform(job) do
    with {:ok, continent} <- set_continent(job),
         {:ok, category} <- set_category(job) do
      {continent, category}
    end
  end

  defp set_continent(
    %{"office_latitude" => "",
      "office_longitude" => ""}), do: @not_set
  defp set_continent(
    %{"office_latitude" => _,
      "office_longitude" => ""}), do: @not_set
  defp set_continent(
    %{"office_latitude" => "",
      "office_longitude" => _}), do: @not_set
  defp set_continent(%{"office_latitude" => latitude_str,
                       "office_longitude" => longitude_str}) do
    {latitude, _} = Float.parse(latitude_str)
    {longitude, _} = Float.parse(longitude_str)
    Geo.geo_to_continent({latitude, longitude})
  end

  defp set_category(%{"profession_id" => id}),
    do: Lookup.get_profession_category(id)

  defp timer_start() do
    {:ok, now} = DateTime.now("Etc/UTC")
    Process.put(@start_time, now)
  end

  defp execution_time() do
    start_dtm = Process.get(@start_time)
    {:ok, now} = DateTime.now("Etc/UTC")
    DateTime.diff(now, start_dtm)
  end

end

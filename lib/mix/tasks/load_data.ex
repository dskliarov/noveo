defmodule Mix.Tasks.LoadData do
  use Mix.Task

  alias Noveo.{Lookup, Repo.Db, Utility}

  @professions_file Application.get_env(:noveo, Noveo.Lookup)[:professions_file]
  @jobs_file Application.get_env(:noveo, Noveo.ContinentsGrouping)[:jobs_file]

  def run(_) do
    Mix.Task.run("app.start")
    Lookup.preload()
    load_professions()
    load_job_postings()
  end

  defp load_professions() do
    @professions_file
    |> Utility.read_file()
    |> Stream.each(&Db.insert_profession/1)
    |> Stream.run()
  end

  defp load_job_postings() do
    @jobs_file
    |> Utility.read_file()
    |> Stream.each(&Db.insert_job_posting/1)
    |> Stream.run()
  end
end

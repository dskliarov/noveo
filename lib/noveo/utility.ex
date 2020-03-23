defmodule Noveo.Utility do

  def read_file(path, modes \\ []) do
    path
    |> Path.expand(__DIR__)
    |> File.stream!(modes)
    |> CSV.decode!(headers: true, strip_fields: true)
  end

end

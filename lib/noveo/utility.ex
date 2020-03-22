defmodule Noveo.Utility do

  def read_file(path) do
    path
    |> Path.expand(__DIR__)
    |> File.stream!
    |> CSV.decode!(headers: true, strip_fields: true)
  end

end

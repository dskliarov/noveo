defmodule NoveoWeb.APIController do
  use NoveoWeb, :controller

  alias Noveo.Repo.Db

  def handle_get(conn, params) do
    case validate_request(params) do
      :ok ->
        %{"longitude" => longitude,
          "latitude" => latitude,
          "radius" => radius} = params

        latitude = Db.sanitize_float(latitude)
        longitude = Db.sanitize_float(longitude)
        radius = Db.sanitize_integer(radius)

        data = Db.find_job_postings({longitude, latitude}, radius * 1000, %{})
        render(conn, conn.assigns.view, data: data);
      _ ->
        conn
        |> put_status(400)
        |> render(:error, message: "Invqlid Request");
    end
  end

  defp validate_request(params) do
      %{
        "type" => "object",
        "properties" => %{
          "longitude" => %{
            "type" => "string"
          },
          "latitude" => %{
            "type" => "string"
          },
          "radius" => %{
            "type" => "string"
          }
        }
      }
      |> ExJsonSchema.Schema.resolve()
      |> ExJsonSchema.Validator.validate(params)
  end

end

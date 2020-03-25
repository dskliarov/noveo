defmodule NoveoWeb.Router do
  use NoveoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", NoveoWeb do
    pipe_through :api

    get(
      "/jobs",
      APIController,
      :handle_get,
      assigns: %{
        view: :job_posting
      }
    )

  end
end

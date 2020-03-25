defmodule Noveo.Repo do
  use Ecto.Repo, otp_app: :noveo, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 50
end

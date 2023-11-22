defmodule Brewnotes.Repo do
  use Ecto.Repo,
    otp_app: :brewnotes,
    adapter: Ecto.Adapters.Postgres
end

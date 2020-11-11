defmodule Underscorecore.Repo do
  use Ecto.Repo,
    otp_app: :underscorecore,
    adapter: Ecto.Adapters.Postgres
end

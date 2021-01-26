defmodule Underscorecore.Models.Artist do
  use Ecto.Schema

  schema "artists" do
    field :name, :string

    timestamps()
  end
end

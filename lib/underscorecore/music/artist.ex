defmodule Underscorecore.Music.Artist do
  use Ecto.Schema

  schema "artists" do
    field :name, :string

    timestamps()
  end
end

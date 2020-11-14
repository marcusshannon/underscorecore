defmodule Underscorecore.Music.Album do
  use Ecto.Schema

  schema "albums" do
    field :name, :string
    field :artwork_url, :string
    belongs_to :artist, Underscorecore.Music.Artist

    timestamps()
  end
end

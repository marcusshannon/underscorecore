defmodule Underscorecore.Music.Album do
  use Ecto.Schema

  schema "albums" do
    field :artist_id, :id
    field :name, :string
    field :artwork_url, :string
    has_one :artist, Underscorecore.Music.Artist

    timestamps()
  end
end

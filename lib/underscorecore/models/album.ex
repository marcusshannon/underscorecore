defmodule Underscorecore.Models.Album do
  use Ecto.Schema

  alias Underscorecore.Models.{Artist, Core, CoreAlbum}

  schema "albums" do
    field :name, :string
    field :artwork_url, :string
    belongs_to :artist, Artist
    many_to_many :cores, Core, join_through: CoreAlbum

    timestamps()
  end
end

defmodule Underscorecore.Cores.CoreAlbum do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cores_albums" do
    belongs_to :core, Underscorecore.Cores.Core
    belongs_to :album, Underscorecore.Music.Album

    timestamps()
  end

  @doc false
  def changeset(core, attrs) do
    core
    |> cast(attrs, [:core_id, :album_id])
    |> validate_required([:core_id, :album_id])
  end
end

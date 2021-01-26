defmodule Underscorecore.Models.CoreAlbum do
  use Ecto.Schema
  import Ecto.Changeset

  alias Underscorecore.Models.Core
  alias Underscorecore.Models.Album

  schema "cores_albums" do
    belongs_to :core, Core
    belongs_to :album, Album
    field :annotation, :string

    timestamps()
  end

  def changeset(core, attrs) do
    core
    |> cast(attrs, [:core_id, :album_id, :annotation])
    |> validate_required([:core_id, :album_id])
  end
end

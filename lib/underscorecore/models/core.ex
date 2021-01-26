defmodule Underscorecore.Models.Core do
  use Ecto.Schema
  import Ecto.Changeset

  alias Underscorecore.Models.{User, CoreAlbum, Album}

  schema "cores" do
    field :name, :string
    field :description, :string
    field :order, {:array, :integer}
    field :albums_count, :integer, virtual: true
    belongs_to :user, User
    many_to_many :albums, Album, join_through: CoreAlbum

    timestamps()
  end

  def changeset(core, attrs) do
    core
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end

defmodule Underscorecore.Cores.Core do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cores" do
    field :name, :string
    field :order, {:array, :integer}

    timestamps()
  end

  @doc false
  def changeset(core, attrs) do
    core
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

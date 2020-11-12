defmodule Underscorecore.Repo.Migrations.CreateCores do
  use Ecto.Migration

  def change do
    create table(:cores) do
      add :name, :string
      add :order, {:array, :integer}

      timestamps()
    end

  end
end

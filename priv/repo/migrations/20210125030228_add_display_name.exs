defmodule Underscorecore.Repo.Migrations.AddDisplayName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
    end

    create unique_index(:users, [:name])
  end
end

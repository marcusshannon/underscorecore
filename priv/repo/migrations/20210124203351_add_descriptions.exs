defmodule Underscorecore.Repo.Migrations.AddDescriptions do
  use Ecto.Migration

  def change do
    alter table(:cores) do
      add :description, :text
    end

    alter table(:cores_albums) do
      add :annotation, :text
    end
  end
end

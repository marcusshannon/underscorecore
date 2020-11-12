defmodule Underscorecore.Repo.Migrations.AddCoresAlbumsTable do
  use Ecto.Migration

  def change do
    create table(:cores_albums) do
      add :core_id, :integer
      add :album_id, :integer

      timestamps()
    end

    create unique_index(:cores_albums, [:core_id, :album_id])
  end
end

defmodule Underscorecore.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :artist_id, :integer
      add :name, :string
      add :artwork_url, :string

      timestamps()
    end
  end
end

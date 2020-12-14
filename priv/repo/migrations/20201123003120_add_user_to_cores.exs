defmodule Underscorecore.Repo.Migrations.AddUserToCores do
  use Ecto.Migration

  def change do
    alter table(:cores) do
      add :user_id, :integer
    end
  end
end

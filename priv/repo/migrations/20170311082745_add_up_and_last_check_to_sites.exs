defmodule Uptom.Repo.Migrations.AddUpAndLastCheckToSites do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      add :up, :boolean
      add :last_checked_at, :utc_datetime
    end
  end
end

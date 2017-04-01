defmodule Uptom.Repo.Migrations.AddNameAndEnabledToSites do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      add :name, :string
      add :enabled, :boolean, null: false, default: true
    end
  end
end

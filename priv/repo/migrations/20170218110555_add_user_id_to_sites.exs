defmodule Uptom.Repo.Migrations.AddUserIdToSites do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      add :user_id, references(:users, on_delete: :delete_all), null: false, index: true
    end
  end
end

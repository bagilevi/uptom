defmodule Uptom.Repo.Migrations.CreateSitePing do
  use Ecto.Migration

  def change do
    create table(:site_pings) do
      add :success, :boolean, default: false, null: false
      add :status_code, :integer
      add :message, :string
      add :site_id, references(:sites, on_delete: :nothing)
      add :started_at, :utc_datetime

      timestamps()
    end
    create index(:site_pings, [:site_id])

  end
end

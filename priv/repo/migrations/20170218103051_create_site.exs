defmodule Uptom.Repo.Migrations.CreateSite do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :url, :string
      add :frequency, :integer

      timestamps()
    end

  end
end

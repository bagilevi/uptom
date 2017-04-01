defmodule Uptom.Site do
  use Uptom.Web, :model

  schema "sites" do
    field :name, :string
    field :url, :string
    field :frequency, :integer
    field :enabled, :boolean
    field :up, :boolean
    field :last_checked_at, Ecto.DateTime
    belongs_to :user, Uptom.User
    has_many :site_pings, Uptom.SitePing, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :frequency, :enabled])
    |> validate_required([:name, :url, :frequency])
    |> validate_inclusion(:frequency, Uptom.Frequency.allowed_values)
    |> clear_status_if_disabled
  end

  defp clear_status_if_disabled(changeset) do
    if changeset.changes[:enabled] == false do
      force_change(changeset, :up, nil)
    else
      changeset
    end
  end
end

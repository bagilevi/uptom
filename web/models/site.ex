defmodule Uptom.Site do
  use Uptom.Web, :model

  schema "sites" do
    field :url, :string
    field :frequency, :integer
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
    |> cast(params, [:url, :frequency])
    |> validate_required([:url, :frequency])
  end
end

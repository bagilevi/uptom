defmodule Uptom.SitePing do
  use Uptom.Web, :model

  schema "site_pings" do
    field :success, :boolean, default: false
    field :status_code, :integer
    field :message, :string
    field :started_at, Ecto.DateTime
    belongs_to :site, Uptom.Site

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:site_id, :started_at, :success, :status_code, :message])
    |> validate_required([:success])
  end
end

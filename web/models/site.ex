defmodule Uptom.Site do
  use Uptom.Web, :model

  schema "sites" do
    field :url, :string
    field :frequency, :integer
    belongs_to :user, Uptom.User

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

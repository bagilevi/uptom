defmodule Uptom.Session do
  use Uptom.Web, :model

  schema "sessions" do
    field :creds, :string
    belongs_to :user, Uptom.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :creds])
    |> validate_required([:user_id, :creds])
  end
end

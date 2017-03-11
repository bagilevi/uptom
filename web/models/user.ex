defmodule Uptom.User do
  use Uptom.Web, :model
  use Coherence.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    coherence_schema

    has_many :sites, Uptom.Site

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email] ++ coherence_fields)
    |> validate_required([:name, :email])
    |> validate_length(:email, min: 1, max: 150)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Password.hash(pass))
        _ ->
          changeset
    end
  end

  defimpl Coherence.DbStore, for: Uptom.User do
    alias Uptom.{Session, Repo}
    
    def get_user_data(_, creds, _id_key) do
      case Repo.one from s in Session, where: s.creds == ^creds, preload: :user do
        %{user: user} -> user
        _ -> nil
      end
    end

    def put_credentials(user, creds , _) do
      case Repo.one from s in Session, where: s.creds == ^creds do
        nil -> %Session{creds: creds}
        session -> session
      end
      |> Session.changeset(%{user_id: user.id})
      |> Repo.insert_or_update
    end

    def delete_credentials(_, creds) do
      case Repo.one from s in Session, where: s.creds == ^creds do
        nil -> nil
        session ->
          Repo.delete session
      end
    end
  end
end

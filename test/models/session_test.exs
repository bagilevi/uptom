defmodule Uptom.SessionTest do
  use Uptom.ModelCase

  alias Uptom.Session

  @valid_attrs %{creds: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Session.changeset(%Session{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Session.changeset(%Session{}, @invalid_attrs)
    refute changeset.valid?
  end
end

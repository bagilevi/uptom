defmodule Uptom.SitePingTest do
  use Uptom.ModelCase

  alias Uptom.SitePing

  @valid_attrs %{message: "some content", status_code: "some content", success: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SitePing.changeset(%SitePing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SitePing.changeset(%SitePing{}, @invalid_attrs)
    refute changeset.valid?
  end
end

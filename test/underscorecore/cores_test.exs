defmodule Underscorecore.CoresTest do
  use Underscorecore.DataCase

  alias Underscorecore.Cores

  describe "cores" do
    alias Underscorecore.Cores.Core

    @valid_attrs %{name: "some name", order: []}
    @update_attrs %{name: "some updated name", order: []}
    @invalid_attrs %{name: nil, order: nil}

    def core_fixture(attrs \\ %{}) do
      {:ok, core} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cores.create_core()

      core
    end

    test "list_cores/0 returns all cores" do
      core = core_fixture()
      assert Cores.list_cores() == [core]
    end

    test "get_core!/1 returns the core with given id" do
      core = core_fixture()
      assert Cores.get_core!(core.id) == core
    end

    test "create_core/1 with valid data creates a core" do
      assert {:ok, %Core{} = core} = Cores.create_core(@valid_attrs)
      assert core.name == "some name"
      assert core.order == []
    end

    test "create_core/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cores.create_core(@invalid_attrs)
    end

    test "update_core/2 with valid data updates the core" do
      core = core_fixture()
      assert {:ok, %Core{} = core} = Cores.update_core(core, @update_attrs)
      assert core.name == "some updated name"
      assert core.order == []
    end

    test "update_core/2 with invalid data returns error changeset" do
      core = core_fixture()
      assert {:error, %Ecto.Changeset{}} = Cores.update_core(core, @invalid_attrs)
      assert core == Cores.get_core!(core.id)
    end

    test "delete_core/1 deletes the core" do
      core = core_fixture()
      assert {:ok, %Core{}} = Cores.delete_core(core)
      assert_raise Ecto.NoResultsError, fn -> Cores.get_core!(core.id) end
    end

    test "change_core/1 returns a core changeset" do
      core = core_fixture()
      assert %Ecto.Changeset{} = Cores.change_core(core)
    end
  end
end

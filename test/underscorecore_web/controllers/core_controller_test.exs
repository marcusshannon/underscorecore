defmodule UnderscorecoreWeb.CoreControllerTest do
  use UnderscorecoreWeb.ConnCase

  alias Underscorecore.App

  @create_attrs %{name: "some name", order: []}
  @update_attrs %{name: "some updated name", order: []}
  @invalid_attrs %{name: nil, order: nil}

  def fixture(:core) do
    {:ok, core} = App.create_core(@create_attrs)
    core
  end

  describe "index" do
    test "lists all cores", %{conn: conn} do
      conn = get(conn, Routes.core_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Cores"
    end
  end

  describe "new core" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.core_path(conn, :new))
      assert html_response(conn, 200) =~ "New Core"
    end
  end

  describe "create core" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.core_path(conn, :create), core: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.core_path(conn, :show, id)

      conn = get(conn, Routes.core_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Core"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.core_path(conn, :create), core: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Core"
    end
  end

  describe "edit core" do
    setup [:create_core]

    test "renders form for editing chosen core", %{conn: conn, core: core} do
      conn = get(conn, Routes.core_path(conn, :edit, core))
      assert html_response(conn, 200) =~ "Edit Core"
    end
  end

  describe "update core" do
    setup [:create_core]

    test "redirects when data is valid", %{conn: conn, core: core} do
      conn = put(conn, Routes.core_path(conn, :update, core), core: @update_attrs)
      assert redirected_to(conn) == Routes.core_path(conn, :show, core)

      conn = get(conn, Routes.core_path(conn, :show, core))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, core: core} do
      conn = put(conn, Routes.core_path(conn, :update, core), core: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Core"
    end
  end

  describe "delete core" do
    setup [:create_core]

    test "deletes chosen core", %{conn: conn, core: core} do
      conn = delete(conn, Routes.core_path(conn, :delete, core))
      assert redirected_to(conn) == Routes.core_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.core_path(conn, :show, core))
      end
    end
  end

  defp create_core(_) do
    core = fixture(:core)
    %{core: core}
  end
end

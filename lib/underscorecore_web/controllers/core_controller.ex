defmodule UnderscorecoreWeb.CoreController do
  use UnderscorecoreWeb, :controller

  alias Underscorecore.Cores
  alias Underscorecore.Cores.Core

  alias Underscorecore.Queries
  alias Underscorecore.Queries.Query

  def index(conn, _params) do
    cores = Cores.list_cores()
    render(conn, "index.html", cores: cores)
  end

  def new(conn, _params) do
    changeset = Cores.change_core(%Core{})
    render(conn, "new.html", changeset: changeset)
  end



  def create(conn, %{"core" => core_params}) do
    case Cores.create_core(core_params) do
      {:ok, core} ->
        conn
        |> put_flash(:info, "Core created successfully.")
        |> redirect(to: Routes.core_path(conn, :show, core))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end



  def show(conn, %{"id" => id}) do
    core = Cores.get_core!(id)
    core_albums = Cores.get_core_albums(id)
    render(conn, "show.html", core: core, core_albums: core_albums)
  end

  def edit(conn, %{"id" => id}) do
    core = Cores.get_core!(id)
    changeset = Cores.change_core(core)
    render(conn, "edit.html", core: core, changeset: changeset)
  end

  def update(conn, %{"id" => id, "core" => core_params}) do
    core = Cores.get_core!(id)

    case Cores.update_core(core, core_params) do
      {:ok, core} ->
        conn
        |> put_flash(:info, "Core updated successfully.")
        |> redirect(to: Routes.core_path(conn, :show, core))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", core: core, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    core = Cores.get_core!(id)
    {:ok, _core} = Cores.delete_core(core)

    conn
    |> put_flash(:info, "Core deleted successfully.")
    |> redirect(to: Routes.core_path(conn, :index))
  end

  def add_search(conn, %{"id" => id}) do 
    core = Cores.get_core!(id)
    core_albums = Cores.get_core_albums(id)
    render(conn, "add_search.html", core: core)
  end

  def add(conn, %{"id" => id, "core_album" => core_album_params}) do
    Underscorecore.Cores.create_core_album(core_album_params)
    core = Cores.get_core!(id)
    
    conn
    |> put_flash(:success, "Album successfully added to core")
    |> render("add_search.html", core: core)
  end

  def search(conn, %{"id" => id, "search" => search_params}) do
    core = Cores.get_core!(id)
    search_results = Underscorecore.Search.search(search_params["term"])
    render(conn, "add_search.html", core: core, search_results: search_results)
  end
end

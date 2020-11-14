defmodule UnderscorecoreWeb.AlbumController do
  use UnderscorecoreWeb, :controller

  alias Underscorecore.Music
  alias Underscorecore.Music.Album

  def index(conn, _params) do
    albums = Music.list_albums()
    render(conn, "index.html", albums: albums)
  end

  def new(conn, _params) do
    changeset = Music.change_album(%Album{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"album" => album_params}) do
    case Music.create_album(album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album created successfully.")
        |> redirect(to: Routes.album_path(conn, :show, album))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    album = Music.get_album!(id)
    cores_with_album = Underscorecore.Cores.cores_with_album(album.id)
    render(conn, "show.html", album: album, cores_with_album: cores_with_album)
  end

  def edit(conn, %{"id" => id}) do
    album = Music.get_album!(id)
    changeset = Music.change_album(album)
    render(conn, "edit.html", album: album, changeset: changeset)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Music.get_album!(id)

    case Music.update_album(album, album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album updated successfully.")
        |> redirect(to: Routes.album_path(conn, :show, album))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", album: album, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Music.get_album!(id)
    {:ok, _album} = Music.delete_album(album)

    conn
    |> put_flash(:info, "Album deleted successfully.")
    |> redirect(to: Routes.album_path(conn, :index))
  end
end

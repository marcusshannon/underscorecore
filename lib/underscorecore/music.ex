defmodule Underscorecore.Music do
  import Ecto.Query, warn: false
  alias Underscorecore.Repo

  alias Underscorecore.Music.{Artist, Album}

  def list_artists do
    Repo.all(Artist)
  end

  def get_artist!(id), do: Repo.get!(Artist, id)

  def upsert_artists(artists) do
    IO.inspect(artists)
    Repo.insert_all(Artist, artists, on_conflict: :nothing, returning: true)
  end

  def upsert_albums(albums) do
    Repo.insert_all(Album, albums, on_conflict: :nothing, returning: true)
  end

  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  def list_albums do
    Repo.all(Album)
  end

  def get_album!(id), do: Repo.get!(Album, id) |> Repo.preload(:artist)
end

defmodule Underscorecore.Cores do
  import Ecto.Query, warn: false
  alias Underscorecore.Repo
  alias Underscorecore.Cores.{Core, CoreAlbum}
  alias Underscorecore.Music.{Artist, Album}

  @doc """
  Returns the list of cores.

  ## Examples

      iex> list_cores()
      [%Core{}, ...]

  """
  def list_cores do
    Repo.all(Core)
  end

  @doc """
  Gets a single core.

  Raises `Ecto.NoResultsError` if the Core does not exist.

  ## Examples

      iex> get_core!(123)
      %Core{}

      iex> get_core!(456)
      ** (Ecto.NoResultsError)

  """
  def get_core!(id), do: Repo.get!(Core, id)

  @doc """
  Creates a core.

  ## Examples

      iex> create_core(%{field: value})
      {:ok, %Core{}}

      iex> create_core(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_core(attrs \\ %{}) do
    %Core{}
    |> Core.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a core.

  ## Examples

      iex> update_core(core, %{field: new_value})
      {:ok, %Core{}}

      iex> update_core(core, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_core(%Core{} = core, attrs) do
    core
    |> Core.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a core.

  ## Examples

      iex> delete_core(core)
      {:ok, %Core{}}

      iex> delete_core(core)
      {:error, %Ecto.Changeset{}}

  """
  def delete_core(%Core{} = core) do
    Repo.delete(core)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking core changes.

  ## Examples

      iex> change_core(core)
      %Ecto.Changeset{data: %Core{}}

  """
  def change_core(%Core{} = core, attrs \\ %{}) do
    Core.changeset(core, attrs)
  end

  def create_core_album(attrs \\ %{}) do
    %CoreAlbum{}
    |> CoreAlbum.changeset(attrs)
    |> Repo.insert()
  end

  def get_core_albums(core_id) do
    Repo.all(from a in "albums", where: a.id in subquery(from c in CoreAlbum, select: c.album_id, where: c.core_id == ^core_id), join: ar in "artists", on: a.artist_id == ar.id, select: %{album_id: a.id, album_name: a.name, artwork_url: a.artwork_url, artist_id: ar.id, artist_name: ar.name})
  end

  def found_in(album_id) do
    Repo.all(from ca in Underscorecore.Cores.CoreAlbum, where: ca.album_id == ^album_id) |> Repo.preload([:core])
  end

  def cores_with_album(album_id) do
      Repo.all(from ca in Underscorecore.Cores.CoreAlbum, where: ca.album_id == ^album_id) |> Repo.preload([:album, :core]) |> Enum.map(&(&1.core))
  end
end

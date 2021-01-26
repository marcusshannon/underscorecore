defmodule Underscorecore.App do
  import Ecto.Query, warn: false
  alias Underscorecore.Repo
  alias Underscorecore.Models.{User, UserToken, Core, CoreAlbum, Album, Artist}
  alias Swoosh.Email
  alias Underscorecore.Mailer

  ## Database getters

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password) && User.confirmed?(user), do: user
  end

  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(cores: cores_with_albums_count_query())
    |> Repo.preload(cores: [albums: &featured_albums_for_cores_preloader/1])
    |> Repo.preload(cores: [:user])
  end

  ## User registration

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  ## Settings

  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs)
  end

  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset = user |> User.email_changeset(%{email: email}) |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs)
  end

  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def change_user_info(user, attrs \\ %{}) do
    User.info_changeset(user, attrs)
  end

  def update_user_info(%User{} = core, attrs) do
    core
    |> User.info_changeset(attrs)
    |> Repo.update()
  end

  ## Session

  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  # Cores
  def list_cores do
    Repo.all(Core)
  end

  def get_core!(id) do
    Repo.get!(Core, id)
    |> Repo.preload(:albums)
    |> Repo.preload(albums: :artist)
    |> Repo.preload(:user)
  end

  def get_cores() do
    Repo.all(cores_with_albums_count_query())
    |> Repo.preload(:user)
    |> Repo.preload(albums: &featured_albums_for_cores_preloader/1)
  end

  def create_core(user, attrs \\ %{}) do
    %Core{user: user}
    |> Core.changeset(attrs)
    |> Repo.insert()
  end

  def update_core(%Core{} = core, attrs) do
    core
    |> Core.changeset(attrs)
    |> Repo.update()
  end

  def delete_core(%Core{} = core) do
    Repo.delete(core)
  end

  def change_core(%Core{} = core, attrs \\ %{}) do
    Core.changeset(core, attrs)
  end

  def create_core_album(attrs \\ %{}) do
    %CoreAlbum{}
    |> CoreAlbum.changeset(attrs)
    |> Repo.insert()
  end

  def delete_core_album!(core_id, album_id) do
    core_album = Repo.get_by!(CoreAlbum, core_id: core_id, album_id: album_id)
    Repo.delete!(core_album)
  end

  def cores_with_albums_count_query() do
    count_query =
      from(ca in CoreAlbum, where: ca.core_id == parent_as(:core).id, select: %{count: count()})

    from(c in Core,
      as: :core,
      inner_lateral_join: ca in subquery(count_query),
      select_merge: %{albums_count: ca.count}
    )
  end

  # Music

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

  def get_album!(id) do
    Repo.get!(Album, id)
    |> Repo.preload(cores: cores_with_albums_count_query())
    |> Repo.preload(cores: [albums: &featured_albums_for_cores_preloader/1])
    |> Repo.preload(cores: :user)
    |> Repo.preload(:artist)
  end

  def featured_albums_query() do
    ranking_query =
      from ca in CoreAlbum,
        select: %{
          album_id: ca.album_id,
          core_id: ca.core_id,
          row_number: over(row_number(), :cores_partition)
        },
        windows: [cores_partition: [partition_by: ca.core_id, order_by: ca.inserted_at]]

    from(a in Album,
      as: :album,
      join: r in subquery(ranking_query),
      as: :rank,
      on: a.id == r.album_id and r.row_number < 5
    )
  end

  def featured_albums_for_cores_preloader(core_ids) do
    Repo.all(
      from([album: a, rank: r] in featured_albums_query(),
        where: r.core_id in ^core_ids,
        select: {r.core_id, a},
        order_by: r.row_number
      )
    )
  end

  # Users

  def cores_from_user(user) do
    Repo.preload(user, :cores)
  end

  # Search

  def search(term) do
    query_params = URI.encode_query(%{"term" => term, "limit" => 3, "entity" => "album"})

    {:ok, response} =
      Finch.build(:get, "https://itunes.apple.com/search?#{query_params}")
      |> Finch.request(Underscorecore.Finch)

    results = Jason.decode!(response.body)["results"]

    datetime = DateTime.from_unix!(System.os_time(:second), :second) |> DateTime.to_naive()

    artists =
      Enum.map(results, fn result ->
        %{
          id: result["artistId"],
          name: result["artistName"],
          updated_at: datetime,
          inserted_at: datetime
        }
      end)

    albums =
      Enum.map(results, fn result ->
        %{
          id: result["collectionId"],
          artist_id: result["artistId"],
          name: result["collectionName"],
          artwork_url: get_scaled_artwork_url(result["artworkUrl60"]),
          updated_at: datetime,
          inserted_at: datetime
        }
      end)

    upsert_artists(artists)
    upsert_albums(albums)

    # artist_map = Enum.reduce(inserted_artists, fn (artist, acc) -> Map.put(acc, artist.id, artist), %{})
    Enum.zip(artists, albums)
  end

  def get_scaled_artwork_url(url) do
    String.trim_trailing(url, "60x60bb.jpg") <> "600x600bb.jpg"
  end

  # For simplicity, this module simply logs messages to the terminal.
  # You should replace it by a proper email or notification tool, such as:
  #
  #   * Swoosh - https://hexdocs.pm/swoosh
  #   * Bamboo - https://hexdocs.pm/bamboo
  #
  defp deliver(to, subject, body) do
    IO.inspect "DELIERING"
    Email.new()
    |> Email.to(to)
    |> Email.from({"_core", "no-reply@underscorecore.com"})
    |> Email.subject(subject)
    |> Email.text_body(body)
    |> Mailer.deliver()
  end


  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "_core - email confirmation", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end


  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "_core - reset password", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "_core - change email", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end

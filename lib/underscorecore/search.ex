defmodule Underscorecore.Search do
  def search(term) do
    query_params = URI.encode_query(%{"term" => term, "limit" => 1, "entity" => "album"})

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

    Underscorecore.Music.upsert_artists(artists)
    Underscorecore.Music.upsert_albums(albums)
    # artist_map = Enum.reduce(inserted_artists, fn (artist, acc) -> Map.put(acc, artist.id, artist), %{})
    Enum.zip(artists, albums)
  end

  def get_scaled_artwork_url(url) do
    String.trim_trailing(url, "60x60bb.jpg") <> "600x600bb.jpg"
  end
end

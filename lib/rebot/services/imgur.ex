defmodule Rebot.Services.Imgur do
  use HTTPoison.Base
  alias Rebot.Services.Imgur.Model

  def gallery(subreddit, filter_albums \\ true) do
    with {:ok, %HTTPoison.Response{body: body}} <- get("/gallery/r/#{subreddit}/top/week", []),
      decoded = body
        |> Poison.decode!(as: %{"data" => [%Model.Image{}]})
        |> Map.get("data")
        |> Enum.filter(fn (image) -> !filter_albums || !image.is_album end)
        |> Enum.sort_by(fn (image) -> image.score end, &>=/2),
      do: {:ok, decoded}
  end

  def process_url(url) do
    "https://api.imgur.com/3" <> url
  end

  def process_request_headers(headers) do
    token = Application.get_env(:rebot, :imgur_token)
    Enum.into(headers, [{"Authorization", "Client-ID #{token}"}])
  end
end

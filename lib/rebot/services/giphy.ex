defmodule Rebot.Services.Giphy do
  use HTTPoison.Base
  alias Rebot.Services.Giphy.Model

  def search(query, lang \\ "it") do
    generic_get("/search", %{"q": query}, lang)
      |> Poison.decode!(as: %{"data" => [%Model.Result{}]})
      |> Map.get("data")
      |> Enum.map(&map_images/1)
  end

  def translate(message, lang \\ "it") do
    generic_get("/translate", %{"s": message}, lang)
      |> Poison.decode!(as: %{"data" => %Model.Result{}})
      |> Map.get("data")
      |> map_images
  end

  def random do
    key = Application.get_env(:rebot, :giphy_key)
    {:ok, %HTTPoison.Response{body: body}} = get("/random", [], params: %{"api_key": key})
    body
      |> Poison.decode!
      |> Map.get("data")
  end

  defp generic_get(path, parameters, lang) do
    key = Application.get_env(:rebot, :giphy_key)
    params = Map.merge(%{"api_key": key, lang: lang}, parameters)
    {:ok, %HTTPoison.Response{body: body}} = get(path, [], params: params)
    body
  end

  defp map_images(result) do
    images = result.images
      |> Enum.into(%{}, fn ({k, image}) -> {k, Model.Image.new(image)} end)

    Map.merge(result, %{images: images})
  end

  def process_url(url) do
    "http://api.giphy.com/v1/gifs" <> url
  end
end

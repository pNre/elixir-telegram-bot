defmodule Rebot.Action.Pics do
  use Rebot.Action
  alias Rebot.Services.ApiAi.Model

  def init do
    {:ok, nil}
  end

  def do_action(chat, "picture.random", %Model.Result{parameters: %{"pictures_source" => source}}, state) when is_binary(source) and byte_size(source) > 0 do
    with {:ok, pictures} <- Rebot.Services.Imgur.gallery(String.replace(source, " ", "")),
    do: pictures
      |> Enum.random
      |> (&Nadia.send_photo(chat.id, &1.link)).()
    {:reply, :ok, state}
  end

  def do_action(_, _, _, state) do
    {:noreply, state}
  end

  def do_inline(_chat, offset, query, state) when byte_size(query) > 0 do
    {:ok, pictures} = Rebot.Services.Imgur.gallery(String.replace(query, " ", ""))
    pics = pictures
      |> Enum.map(&Rebot.Services.Imgur.Model.Image.as_inline_result/1)

    gifs = Rebot.Services.Giphy.search(query)
      |> Enum.map(&Rebot.Services.Giphy.Model.Result.as_inline_result/1)

    results = Utils.Enum.combine(pics, gifs)

    {:reply, {:ok, pics ++ gifs}, state}
  end

  def do_inline(_, _, _, state) do
    {:noreply, state}
  end
end

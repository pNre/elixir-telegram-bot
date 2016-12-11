defmodule Rebot.Update do
  alias Nadia.Model
  alias Rebot.Services.ApiAi
  alias Rebot.Services.Giphy

  # message
  def handle(%Model.Update{message: %Model.Message{chat: _chat, text: "/start"}}) do
  end

  def handle(%Model.Update{message: %Model.Message{chat: chat, text: text}}) do
    {:ok, %ApiAi.Model.Query{result: result}} = ApiAi.query(text, chat.id)
    %Rebot.Services.ApiAi.Model.Result{action: action} = result
    Rebot.Action.Supervisor.action(chat, action, result)
  end

  # inline_query
  def handle(%Model.Update{inline_query: %{from: chat, id: id, offset: offset, query: query}}) do
    Rebot.Action.Supervisor.inline(chat, id, offset, query)
  end

  # Utility methods
  def reply(message \\ nil, chat, lang \\ "it") do
    gifs = if message, do: Giphy.translate(message, lang), else: Giphy.random

    case gifs do
      %Giphy.Model.Result{images: %{"downsized" => %Giphy.Model.Image{url: url}}} ->
        {:ok, _} = Nadia.send_document(chat.id, url)
      _ ->
        {:ok, _} = Nadia.send_message(chat.id, message)
    end
  end
end

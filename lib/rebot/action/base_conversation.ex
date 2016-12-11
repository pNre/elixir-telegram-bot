defmodule Rebot.Action.BaseConversation do
  use Rebot.Action
  alias Rebot.Services.ApiAi.Model

  def init do
    {:ok, nil}
  end

  def do_action(chat, "input.unknown", %Model.Result{fulfillment: %Model.Fulfillment{speech: speech}}, state) do
    Rebot.Update.reply(speech, chat, "it")
    {:reply, :ok, state}
  end

  def do_action(chat, "input.to-gif", %Model.Result{fulfillment: %Model.Fulfillment{speech: speech}, parameters: params}, state) do
    Rebot.Update.reply(speech, chat, params["lang"] || "it")
    {:reply, :ok, state}
  end

  def do_action(_, _, _, state) do
    {:noreply, state}
  end

  def do_inline(_, _, _, state) do
    {:noreply, state}
  end
end

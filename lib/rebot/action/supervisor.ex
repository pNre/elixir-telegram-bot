defmodule Rebot.Action.Supervisor do
  use Supervisor
  require Logger

  @name Rebot.Action.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: @name])
  end

  def init(:ok) do
    children = [
      worker(Rebot.Action.Feed, [Rebot.Action.Feed]),
      worker(Rebot.Action.BaseConversation, [Rebot.Action.BaseConversation]),
      worker(Rebot.Action.Pics, [Rebot.Action.Pics])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def action(chat, action, result) do
    Logger.debug("Performing #{action}")

    Nadia.send_chat_action(chat.id, "typing")

    handled = Supervisor.which_children(Rebot.Action.Supervisor)
      |> Enum.map(&(&1 |> Tuple.to_list |> Enum.at(1)))
      |> Enum.map(&({GenServer, :call, [&1, {:action, chat, action, result}]}))
      |> :rpc.parallel_eval
      |> Enum.any?(fn (result) -> result == :ok end)

    unless handled do
      Nadia.send_message(chat.id, "😶")
    end
  end

  def inline(chat, query_id, offset, query) do
    Logger.debug("Inlining #{query}")

    mapper = fn (result) ->
      case result do
        {:ok, results} -> results
        _ -> nil
      end
    end

    results = Supervisor.which_children(Rebot.Action.Supervisor)
      |> Enum.map(&(&1 |> Tuple.to_list |> Enum.at(1)))
      |> Enum.map(&({GenServer, :call, [&1, {:inline, chat, offset, query}]}))
      |> :rpc.parallel_eval
      |> Enum.map(mapper)
      |> Enum.filter(&(&1))
      |> Enum.flat_map(&(&1))
      |> Enum.take(50)

    Logger.debug("Sending #{length(results)} inline results")

    :ok = Nadia.answer_inline_query(query_id, results)
  end

end

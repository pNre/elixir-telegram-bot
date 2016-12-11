defmodule Rebot.Action.Feed do
  use Rebot.Action
  alias Rebot.Services.ApiAi.Model
  require Logger

  @feeds %{"hackernews" => "https://news.ycombinator.com/rss",
           "producthunt" => "https://www.producthunt.com/feed.atom",
           "reddit" => "http://www.reddit.com/.rss"}

  @feed_interval 1000 * 60 * 10

  def init do
    {:ok, nil}
  end

  def do_action(chat, "feed.list", _, state) do
    tasks = Rebot.User.Registry.online(Rebot.User.Registry, chat.id)
      |> Rebot.User.list_of_tasks

      {:ok, _} = case tasks do
        tasks when length(tasks) > 0 ->
          tasks
            |> Enum.join("\n")
            |> (&Nadia.send_message(chat.id, &1)).()
        _ ->
          Nadia.send_message(chat.id, "Lista vuota")
      end

      {:reply, :ok, state}
  end

  def do_action(chat, "feed.subscribe", %Model.Result{parameters: %{"feed_name" => name}}, state) when is_binary(name) and byte_size(name) > 0 do
    Logger.info("Subscribing #{name}")
    case Map.get(@feeds, name) do
      url when is_binary(url) ->
        Rebot.Action.Feed.Task.observe(url, chat, @feed_interval)
      _ ->
        Nadia.send_message(chat.id, "Feed sconosciuto")
    end
    {:reply, :ok, state}
  end

  def do_action(chat, "feed.subscribe", %Model.Result{resolvedQuery: query}, state) do
    case Regex.run(~r/(http|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])?/, query) do
      [url | _rest] ->
        Logger.info("Subscribing #{url}")
        Rebot.Action.Feed.Task.observe(url, chat, @feed_interval)
        {:reply, :ok, state}
      _ ->
        {:noreply, state}
    end
  end

  def do_action(_, _, _, state) do
    {:noreply, state}
  end

  def do_inline(_, _, _, state) do
    {:noreply, state}
  end
end

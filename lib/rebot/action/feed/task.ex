defmodule Rebot.Action.Feed.Task do
  require Logger

  def observe(feed, chat, interval) do
    user = Rebot.User.Registry.online(Rebot.User.Registry, chat.id)
    Rebot.User.register_task(user, feed, fetch(chat, feed), interval)
  end

  defp fetch(chat, url) do
    {:ok, _} = Nadia.send_message(chat.id, "👌")

    fn (state) ->
      Logger.debug("Fetching #{url}")

      {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url, [], [follow_redirect: true])
      {:ok, feed, _} = FeederEx.parse(body)

      current_link = case state do
        %{link: link} -> link
        _ -> nil
      end

      case feed do
        %FeederEx.Feed{entries: [%{link: link} = first | _]} when link != current_link ->
          {:ok, _} = Nadia.send_message(chat.id, "<b>#{first.title}</b>\n#{first.link}", [parse_mode: "HTML"])
          {:ok, first}
        _ ->
          {:ok, state}
      end
    end
  end

end

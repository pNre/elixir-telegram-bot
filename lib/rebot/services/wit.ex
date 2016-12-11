defmodule Rebot.Services.Wit do
  use HTTPoison.Base

  def message(message) do
    version = Application.get_env(:rebot, :wit_version)
    {:ok, %HTTPoison.Response{body: body}} = get("/message", [], params: %{"v": version, "q": message})
    body
  end

  def converse(session_id, message \\ nil, context \\ nil) do
    version = Application.get_env(:rebot, :wit_version)

    request_body = context
      |> Poison.encode!

    params = if message do
      %{"v": version, "q": message, "session_id": session_id}
    else
      %{"v": version, "session_id": session_id}
    end

    {:ok, %HTTPoison.Response{body: response_body}} = post("/converse", request_body, [{"Content-Type", "application/json"}], params: params)
    Rebot.Services.Wit.Model.Converse.new(response_body)
  end

  def process_url(url) do
    "https://api.wit.ai" <> url
  end

  def process_request_headers(headers) do
    bearer = Application.get_env(:rebot, :wit_token)
    Enum.into(headers, [{"Authorization", "Bearer #{bearer}"}])
  end

  def process_response_body(body) do
    body
      |> Poison.decode!
  end
end

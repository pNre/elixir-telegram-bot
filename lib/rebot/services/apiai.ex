defmodule Rebot.Services.ApiAi do
  use HTTPoison.Base
  alias Rebot.Services.ApiAi.Model

  def query(message, sessionId, lang \\ "it", contexts \\ []) do
    version = Application.get_env(:rebot, :apiai_version)

    body_params = %{
      "query" => message,
      "sessionId" => sessionId,
      "lang" => lang,
      "contexts" => contexts
    }

    request_body = body_params
      |> Poison.encode!

    with {:ok, %HTTPoison.Response{body: body}} <- post("/query", request_body, [{"Content-Type", "application/json; charset=utf-8"}], params: %{"v": version}),
      decoded = body |> Poison.decode!(as: %Model.Query{result: %Model.Result{}, status: %Model.Status{}}),
      do: {:ok, decoded}
  end

  def process_url(url) do
    "https://api.api.ai/v1" <> url
  end

  def process_request_headers(headers) do
    bearer = Application.get_env(:rebot, :apiai_token)
    Enum.into(headers, [{"Authorization", "Bearer #{bearer}"}])
  end
end

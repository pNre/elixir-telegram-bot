defmodule Rebot do
  use Application

  def start(_start_type, _start_args) do
    certfile = Application.get_env(:rebot, :certfile)
    webhook_url = Application.get_env(:rebot, :webhook_url)
    Nadia.API.request("setWebhook", [url: webhook_url, certificate: certfile, max_connections: "10"], :certificate)
    Rebot.Supervisor.start_link
  end
end

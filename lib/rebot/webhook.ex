defmodule Rebot.Webhook do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    keyfile = Application.get_env(:rebot, :keyfile)
    certfile = Application.get_env(:rebot, :certfile)
    {:ok, _} = Plug.Adapters.Cowboy.https(__MODULE__, [], [port: 8443, keyfile: keyfile, certfile: certfile])
  end

  post "/webhook" do
    {:ok, data, _} = Plug.Conn.read_body(conn)
    {:ok, data} = Poison.decode(data, keys: :atoms)

    IO.inspect(data)

    update = Nadia.Parser.parse_result([data], "getUpdates")
    Task.Supervisor.start_child(Rebot.UpdateSupervisor, Rebot.Update, :handle, update)

    conn
      |> send_resp(:ok, "")
      |> halt
  end
end

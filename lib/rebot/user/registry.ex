defmodule Rebot.User.Registry do
  use GenServer

  ## Client
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: Rebot.User.Registry)
  end

  def online(server, id) do
    GenServer.call(server, {:online, id})
  end

  ## Server
  def init(:ok) do
    {:ok, {%{}, %{}}}
  end

  def handle_call({:online, id}, _from, {users, references}) do
    if Map.has_key?(users, id) do
      {:reply, Map.get(users, id), {users, references}}
    else
      {:ok, user} = Rebot.User.Supervisor.start_user(id)
      reference = Process.monitor(user)
      references = Map.put(references, reference, id)
      users = Map.put(users, id, user)
      {:reply, user, {users, references}}
    end
  end

  def handle_info({:DOWN, reference, :process, _, _}, {users, references}) do
    {id, references} = Map.pop(references, reference)
    users = Map.delete(users, id)
    {:noreply, {users, references}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

end

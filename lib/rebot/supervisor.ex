defmodule Rebot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Rebot.Webhook, []),
      worker(Rebot.User.Registry, []),
      supervisor(Rebot.Action.Supervisor, []),
      supervisor(Rebot.User.Supervisor, []),
      supervisor(Task.Supervisor, [[name: Rebot.User.TaskSupervisor, restart: :transient]], id: Rebot.User.TaskSupervisor),
      supervisor(Task.Supervisor, [[name: Rebot.UpdateSupervisor]], id: Rebot.UpdateSupervisor)
    ]

    supervise(children, strategy: :rest_for_one)
  end

end

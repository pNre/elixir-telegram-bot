defmodule Rebot.User do
  @enforce_keys [:chat_id]
  defstruct chat_id: nil, tasks: %{names: %{}, pids: %{}}
  @type t :: %Rebot.User{chat_id: String.t, tasks: %{}}

  def start_link(id) do
    Agent.start_link(fn -> %Rebot.User{chat_id: id} end)
  end

  def list_of_tasks(user) do
    Agent.get(user, fn (user) -> user.tasks.names end)
      |> Map.keys
  end

  def register_task(user, name, fun, interval) do
    # get the scheduled tasks
    tasks = Agent.get(user, fn (user) -> user.tasks end)

    # if a task by the same name was already started, terminate it
    if Map.has_key?(tasks.names, name) do
      Task.Supervisor.terminate_child(Rebot.User.TaskSupervisor, tasks.names[name])
    end

    # start the new task
    {:ok, pid} = Task.Supervisor.start_child(Rebot.User.TaskSupervisor, fn () -> run_fn(fun, interval) end)

    names = Map.put(tasks.names, name, pid)
    pids = Map.put(tasks.pids, pid, name)
    Agent.update(user, fn (user) -> Map.merge(user, %{tasks: %{names: names, pids: pids}}) end)
  end

  defp run_fn(func, interval, state \\ nil) do
    {:ok, state} = func.(state)
    :timer.sleep(interval)
    run_fn(func, interval, state)
  end
end

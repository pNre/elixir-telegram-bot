defmodule Rebot.User.Supervisor do
  use Supervisor

  @name Rebot.User.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_user(id) do
    Supervisor.start_child(@name, [id])
  end

  def init(:ok) do
    children = [
      worker(Rebot.User, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end

defmodule Rebot.Action do
  defmacro __using__(_) do
    quote do
      use GenServer

      def start_link(name) do
        GenServer.start_link(__MODULE__, [], name: name)
      end

      def action(server, action, chat, result) do
        GenServer.call(server, {:action, chat, action, result})
      end

      def inline(server, chat, offset, query) do
        GenServer.call(server, {:inline, chat, offset, query})
      end

      def handle_call({:action, chat, action, result}, _from, state) do
        do_action(chat, action, result, state)
      end

      def handle_call({:inline, chat, offset, query}, _from, state) do
        do_inline(chat, offset, query, state)
      end
    end
  end
end

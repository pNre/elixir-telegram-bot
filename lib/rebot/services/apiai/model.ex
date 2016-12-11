defmodule Rebot.Services.ApiAi.Model do
  defmodule Message do
    defstruct type: 0,
              speech: nil

    @type t :: %Message{type: integer,
                        speech: String.t}
  end

  defmodule Fulfillment do
    defstruct speech: nil,
              messages: []

    @type t :: %Fulfillment{speech: String.t,
                            messages: list(Message.t)}
  end

  defmodule Metadata do
    defstruct intentId: nil,
              webhookUsed: nil,
              intentName: nil

    @type t :: %Metadata{intentId: String.t,
                         webhookUsed: String.t,
                         intentName: String.t}
  end

  defmodule Result do
    defstruct source: nil,
              resolvedQuery: nil,
              action: nil,
              actionIncomplete: false,
              parameters: %{},
              contexts: [],
              fulfillment: %Fulfillment{},
              score: 0,
              metadata: %Metadata{}

    @type t :: %Result{source: String.t,
                       resolvedQuery: String.t,
                       action: String.t,
                       actionIncomplete: boolean,
                       parameters: %{},
                       contexts: list(Context.t),
                       fulfillment: Fulfillment.t,
                       score: float,
                       metadata: Metadata.t}
  end

  defmodule Status do
    defstruct code: nil,
              errorType: nil,
              errorId: nil,
              errorDetails: nil

    @type t :: %Status{code: pos_integer,
                       errorType: String.t,
                       errorId: String.t,
                       errorDetails: String.t}
  end

  defmodule Query do
    @derive [Poison.Encoder]

    defstruct id: nil,
              timestamp: nil,
              result: nil,
              status: nil,
              sessionId: nil

    @type t :: %Query{id: String.t,
                         timestamp: String.t,
                         result: Result.t,
                         status: Status.t,
                         sessionId: String.t}
  end
end

defmodule Rebot.Services.Wit.Model do
  defmodule Converse do
    defstruct type: nil,
              msg: nil,
              quickreplies: nil,
              action: nil,
              entities: nil,
              confidence: nil

    @type t :: %Converse{type: String.t,
                         msg: String.t,
                         quickreplies: [...],
                         action: String.t,
                         entities: %{},
                         confidence: float}

    use ExConstructor
  end
end

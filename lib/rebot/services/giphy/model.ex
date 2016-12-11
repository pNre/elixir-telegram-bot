defmodule Rebot.Services.Giphy.Model do
  defmodule Result do
    @derive [Poison.Encoder]

    defstruct id: nil,
              images: %{}

    @type t :: %Result{id: String.t,
                       images: %{binary => Image.t}}

    def as_inline_result(result) do
      small = result.images["fixed_height_small"]
      downsized = result.images["downsized"]
      %Nadia.Model.InlineQueryResult.Gif{id: "giphy-#{result.id}",
                                         gif_url: downsized.url,
                                         gif_width: (with {size, _} <- Integer.parse(downsized.width), do: size),
                                         gif_height: (with {size, _} <- Integer.parse(downsized.height), do: size),
                                         thumb_url: small.url}
    end
  end

  defmodule Image do
    @derive [Poison.Encoder]

    defstruct url: nil,
              width: 0,
              height: 0,
              size: 0

    @type t :: %Image{url: String.t,
                      width: pos_integer,
                      height: pos_integer,
                      size: pos_integer}

    use ExConstructor
  end
end

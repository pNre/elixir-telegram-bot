defmodule Rebot.Services.Imgur.Model do
  defmodule Image do
    @derive [Poison.Encoder]

    defstruct id: nil,
              link: nil,
              width: nil,
              height: nil,
              type: nil,
              is_album: nil,
              score: 0

    @type t :: %Image{id: String.t,
                      link: String.t,
                      width: pos_integer,
                      height: pos_integer,
                      type: String.t,
                      is_album: boolean,
                      score: integer}

    def thumbnail_url(image) do
      with url <- URI.parse(image.link),
        path <- "#{Path.rootname(url.path)}t#{Path.extname(url.path)}",
        do: URI.to_string(%URI{url | path: path})
    end

    def as_inline_result(image) do
      %Nadia.Model.InlineQueryResult.Photo{id: "imgur-#{image.id}",
                                           photo_url: image.link,
                                           thumb_url: thumbnail_url(image),
                                           photo_width: image.width,
                                           photo_height: image.height}
    end
  end
end

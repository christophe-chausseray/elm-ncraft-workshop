module Image exposing (Image, imageListDecoder)

import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required, requiredAt)

type alias Image =
  { thumbnailUrl : String
  , url : String
  }

imageDecoder : Decoder Image
imageDecoder =
  Decode.succeed Image
    |> requiredAt ["urls", "thumb"] string
    |> requiredAt ["urls", "regular"] string

imageListDecoder : Decoder (List Image)
imageListDecoder =
  field "results" (list imageDecoder)

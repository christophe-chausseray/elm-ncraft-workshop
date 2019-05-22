module Image exposing (Format(..), filterImages, Image, imageListDecoder)

import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required, requiredAt)

type alias Image =
  { thumbnailUrl : String
  , url : String
  , height : Int
  , width : Int
  }

type Format =
  Portrait
  | Landscape
  | Any

imageDecoder : Decoder Image
imageDecoder =
  Decode.succeed Image
    |> requiredAt ["urls", "thumb"] string
    |> requiredAt ["urls", "regular"] string
    |> requiredAt ["height"] int
    |> requiredAt ["width"] int

imageListDecoder : Decoder (List Image)
imageListDecoder =
  field "results" (list imageDecoder)

filterImages : Format -> List Image -> List Image
filterImages format images =
  case format of
    Landscape ->
        List.filter (\image -> image.width > image.height) images
    Portrait ->
        List.filter (\image -> image.height > image.width) images
    Any ->
        images

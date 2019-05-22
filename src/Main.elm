module Main exposing (main)

import Browser
import Http
import Html exposing (..)
import Html.Attributes exposing (class, type_, src, style)
import Html.Events exposing (onInput, onSubmit)
import Image exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = InputChanged String
    | FormSubmitted
    | ResponseReceived (Result Http.Error (List Image))

type alias Model =
    {searchTerms : String
    , images : List Image
    , message : String}

init : () -> ( Model, Cmd Msg )
init _ =
    ( { searchTerms = ""
      , images = []
      , message = ""
      }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [ class "title" ] [ text "elm image search" ]
        , viewForm
        , viewMessage model
        , viewResults model
        ]


viewForm : Html Msg
viewForm =
    form [ onSubmit FormSubmitted
         , style "padding-bottom" "1rem" ]
        [ input
            [ type_ "text"
            , class "medium input"
            , onInput InputChanged
            ]
            []
        ]

viewMessage : Model -> Html Msg
viewMessage model =  
    if model.message /= "" then
        div [ class "notification is-danger" ] 
        [ button [ class "delete" ] []
        , text model.message 
        ]
    else
        text ""

viewResults : Model -> Html Msg
viewResults model =
    div [ class "columns is-multiline" ] (List.map viewThumbnail model.images)

viewThumbnail : Image -> Html Msg
viewThumbnail image =
    div [ class "column is-one-quarter" ]
        [ img [ src image.thumbnailUrl ] [] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputChanged value ->
            ( { model | searchTerms = value }, Cmd.none )
        FormSubmitted ->
            let
                httpCommand = Http.get
                    { url =
                        "https://unsplash.noprod-b.kmt.orange.com"
                        ++ "/search/photos?query="
                        ++ model.searchTerms
                    , expect = Http.expectJson ResponseReceived imageListDecoder
                    }
                in
                ( model, httpCommand )
        ResponseReceived (Ok images) ->
            ({ model | images = images }, Cmd.none)
        ResponseReceived (Err _) ->
            ({ model | message = "Communication error" }, Cmd.none)

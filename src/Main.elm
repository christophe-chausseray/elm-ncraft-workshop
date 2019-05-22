module Main exposing (main)

import Browser
import Http
import Html exposing (..)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (onInput, onSubmit)


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
    | ResponseReceived (Result Http.Error String)

type alias Model =
    String

type Result error value
    = Ok value
    | Err error

init : () -> ( Model, Cmd Msg )
init _ =
    ( "", Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [ class "title" ] [ text "elm image search" ]
        , viewForm
        ]


viewForm : Html Msg
viewForm =
    form []
        [ input
            [ type_ "text"
            , class "medium input"
            , onInput InputChanged
            , onSubmit FormSubmitted
            ]
            []
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputChanged value ->
            ( value, Cmd.none )
        FormSubmitted ->
            let
                httpCommand = Http.get
                    { url =
                        "https://unsplash.noprod-b.kmt.orange.com"
                        ++ "/search/photos?query="
                        ++ model
                    , expect = Http.expectString ResponseReceived
                    }
                in
                ( model, httpCommand )

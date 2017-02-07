module Flash exposing (..)

import Html exposing (..)
import Html.Attributes as Attribs exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Json exposing (..)
import PubSub


type alias Model =
    { info : Maybe String
    , warning : Maybe String
    , error : Maybe String
    }


type Flash
    = Info String
    | Warning String
    | Error String


type Msg
    = Text Flash
    | Close String


subscriptions : Model -> Sub Msg
subscriptions model =
    PubSub.subscribe "flash" decodeMsg

decodeMsg : Decoder Msg
decodeMsg =
    Json.map Text decodeFlash

decodeFlash : Decoder Flash
decodeFlash =
    oneOf [ Json.map Error (field "error" string)
          , Json.map Warning (field "warning" string)
          , Json.map Info (field "info" string)
          ]


init : ( Model, Cmd Msg )
init =
    Model Nothing Nothing Nothing ! []

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Text (Info info) ->
            { model | info = Just info } ! []

        Text (Warning warning) ->
            { model | warning = Just warning } ! []

        Text (Error error) ->
            { model | error = Just error } ! []

        Close "info" ->
            { model | info = Nothing } ! []

        Close "warning" ->
            { model | warning = Nothing } ! []

        Close "danger" ->
            { model | error = Nothing } ! []

        Close _ ->
            model ! []


view : Model -> Html Msg
view { info, warning, error } =
    div [] <|
        viewChild "info" info
            ++ viewChild "warning" warning
            ++ viewChild "danger" error


viewChild : String -> Maybe String -> List (Html Msg)
viewChild type_ =
    let
        class =
            "alert-" ++ type_

        classes =
            String.join " " [ class, "alert", "alert-dismissible" ]

        html text =
            [ div
                [ Attribs.class classes
                , Attribs.attribute "role" "alert"
                ]
                [ button
                    [ Attribs.type_ "button"
                    , Attribs.class "close"
                    , Attribs.attribute "aria-label" "Close"
                    , onClick (Close type_)
                    ]
                    [ span [ Attribs.attribute "aria-hidden" "true" ] [ Html.text "×" ]
                    ]
                , Html.text text
                ]
            ]
    in
        Maybe.map html >> Maybe.withDefault []

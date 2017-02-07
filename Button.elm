module Button exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as Enc exposing (..)

import PubSub

type alias Model =
    { label : String
    , payload : Value
    }

type Msg = Click


init : ( Model, Cmd Msg )
init =
    let
        payload = Enc.object [ ("info", string "The button was pressed!") ]
    in
        Model "press" payload ! []

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Click ->
            model ! [ PubSub.publish "flash" model.payload ]

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
            
view : Model -> Html Msg
view {label} =
    button [ class "btn btn-default"
           , onClick Click
           ]
    [ text label ]

module Main exposing (..)

import Html exposing (Html, program, div)
import Html.Attributes exposing (class)
import Flash
import Button

main : Program Never Model Msg
main = program
       { init = init
       , update = update
       , subscriptions = subscriptions
       , view = view
       }

type alias Model =
    { flash : Flash.Model
    , button : Button.Model
    }

type Msg
    = FlashMsg Flash.Msg
    | ButtonMsg Button.Msg
    

init : ( Model, Cmd Msg )
init =
    let
        (flashModel, flashCmd) =
            Flash.init

        (buttonModel, buttonCmd) = 
            Button.init
                
    in
        Model flashModel buttonModel ! [ Cmd.map FlashMsg flashCmd
                                       , Cmd.map ButtonMsg buttonCmd
                                       ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FlashMsg flashMsg ->
            let
                (flashModel, flashCmd) =
                    Flash.update flashMsg model.flash
            in
                { model | flash = flashModel } ! [ Cmd.map FlashMsg flashCmd ]

        ButtonMsg buttonMsg ->
            let
                (buttonModel, buttonCmd) =
                    Button.update buttonMsg model.button
            in
                {model | button = buttonModel} ! [ Cmd.map ButtonMsg buttonCmd ]
            

subscriptions : Model -> Sub Msg
subscriptions {flash, button} =
    Sub.batch [ flash |> Flash.subscriptions |> Sub.map FlashMsg
              , button |> Button.subscriptions |> Sub.map ButtonMsg
              ]
    

view : Model -> Html Msg
view {flash, button} =
    div [ class "container"]
        [ div [ class "row" ]
              [ div [ class "panel panel-default"] 
                    [ div [ class "panel-body"] 
                          [ flash |> Flash.view |> Html.map FlashMsg
                          , button |> Button.view |> Html.map ButtonMsg
                          ]
                    ]
              ]
        ]

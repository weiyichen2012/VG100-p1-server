module OnlineBattle1Subscriptions exposing (..)

import BasicFunction exposing (serverMsg)
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import OnlineBattle1Type exposing (Job(..), Model)
import Time
import Type exposing (Msg(..))



--subscriptions for OnlineBattle1


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.job of
        Host ->
            Sub.batch
                [ serverMsg ServerMsg
                , onAnimationFrameDelta Tick
                , onKeyDown (Decode.map keyDown keyCode)
                , onKeyUp (Decode.map keyUp keyCode)
                ]

        Client ->
            Sub.batch
                [ serverMsg ServerMsg
                , onAnimationFrameDelta Tick
                , onKeyDown (Decode.map keyDown keyCode)
                , onKeyUp (Decode.map keyUp keyCode)
                ]



--keyDown: a key press down


keyDown : Int -> Msg
keyDown keyCode =
    KeyDown keyCode



--keyUp: a key press up


keyUp : Int -> Msg
keyUp keyCode =
    KeyUp keyCode

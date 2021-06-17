module MenuSubscriptions exposing (subscriptions)

import BasicFunction exposing (serverMsg)
import MenuConstant exposing (..)
import MenuType exposing (MenuStatus(..), Model)
import Time
import Type exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.menuStatus of
        Hall ->
            Sub.batch
                [ serverMsg ServerMsg
                , Time.every 1000 (\posix -> OnMouseUp refreshHallButtonId)
                --, Time.every 16 Tick
                ]

        Room ->
            Sub.batch
                [ serverMsg ServerMsg
                , Time.every 1000 (\posix -> OnMouseUp refreshRoomButtonId)
                --, Time.every 16 Tick
                ]

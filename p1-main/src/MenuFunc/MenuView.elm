module MenuView exposing (view)

import HallView
import Html exposing (Html, div, input)
import MainModel
import MenuType exposing (Client, MenuStatus(..), Model)
import RoomView
import Type exposing (Msg(..))


view : MainModel.Model -> Html Msg
view model =
    case model.menuModel.menuStatus of
        Hall ->
            HallView.view model

        Room ->
            RoomView.view model

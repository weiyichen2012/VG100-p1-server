module MainView exposing (view)

import Html exposing (Html)
import MainModel exposing (Model)
import MenuView
import OnlineBattle1View
import Type exposing (Msg, MainModelStatus(..))



--view: do individual view for different mainStatus


view : Model -> Html Msg
view model =
    case model.mainStatus of
        Menu ->
            MenuView.view model

        OnlineBattle1 ->
            OnlineBattle1View.view model
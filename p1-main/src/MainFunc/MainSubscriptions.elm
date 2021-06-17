module MainSubscriptions exposing (subscriptions)

import MainModel exposing (Model)
import MenuSubscriptions
import OnlineBattle1Subscriptions
import Type exposing (MainModelStatus(..), Msg(..), Pos)



--subscriptions: do individual subscriptions for different mainStatus


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.mainStatus of
        Menu ->
            MenuSubscriptions.subscriptions model.menuModel

        OnlineBattle1 ->
            OnlineBattle1Subscriptions.subscriptions model.onlineBattle1Model
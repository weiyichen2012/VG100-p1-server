module OnlineBattle1Update exposing (update)

import OnlineBattle1Type exposing (AliveStatus(..), Ball, DelayAction(..), Job(..), Model, Paddle, Scene)
import OnlineBattle1UpdateClient exposing (updateClient)
import OnlineBattle1UpdateHost exposing (updateHost)
import Type exposing (CollisionBox(..), MainModelStatus(..), Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model.job of
        Host ->
            updateHost msg ( model, Cmd.none )

        Client ->
            updateClient msg ( model, Cmd.none )

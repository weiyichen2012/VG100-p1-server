module MainInit exposing (init)

import Array
import Constant exposing (..)
import MainModel exposing (Model)
import MenuInit
import OnlineBattle1Init
import Type exposing (DisplayIndex, IfCollide(..), LineSegment, MainModelStatus(..), Msg)



--init: whole game initiator


init : () -> ( Model, Cmd Msg )
init a =
    ( Model (Array.fromList [ buttonNormalColor, buttonNormalColor ]) (DisplayIndex 0.5) Menu MenuInit.init (OnlineBattle1Init.init "Host"), Cmd.none )

module MenuInit exposing (init)

import Array
import MenuConstant exposing (..)
import MenuType exposing (Client, GameStatus(..), MenuStatus(..), Model)
import Type exposing (BattleInformation(..))
import Constant exposing (..)


init : Model
init =
    Model
        Hall
        (Array.fromList (List.map (\e -> buttonNormalColor) (List.range 1 buttonNum)))
        999
        None
        (Array.fromList [])
        defaultClient
        ""
        (Array.fromList [])
        defaultGameRoom
        ""

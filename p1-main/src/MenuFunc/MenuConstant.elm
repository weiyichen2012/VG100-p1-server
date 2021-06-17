module MenuConstant exposing (..)

import Array
import MenuType exposing (Client, GameRoom, GameStatus(..), GameRoomBasicStatus)


defaultClient : Client
defaultClient =
    Client "defaultClient" "defaultClient" "defaultClient"

defaultGameRoomBasicStatus : GameRoomBasicStatus
defaultGameRoomBasicStatus =
    GameRoomBasicStatus "" "" 0 Battle

defaultGameRoom : GameRoom
defaultGameRoom =
    GameRoom "" "" (Array.fromList []) Battle

buttonNum =
    42


buttonIdFrom =
    0


createRoomButtonId =
    0


refreshHallButtonId =
    1


ownClientNameTextBoxId =
    2


confirmOwnClientNameButtonId =
    3

refreshRoomButtonId =
    4

ownRoomNameTextBoxId =
    5

confirmOwnRoomNameButtonId =
    6

joinRoomButtonStartId =
    7

joinRoomButtonEndId =
    37

quitRoomButtonId =
    38

startRoomGameButtonId =
    39

-- 40 41
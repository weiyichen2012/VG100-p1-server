module MenuType exposing (..)

import Array exposing (Array)
import Type exposing (BattleInformation)


type alias Client =
    { uuid : String
    , name : String
    , roomUUID : String
    }


type alias GameRoom =
    { uuid : String
    , name : String
    , clientList : Array Client
    , gameStatus : GameStatus
    }

type alias GameRoomBasicStatus =
    { uuid : String
    , name : String
    , playerNum : Int
    , gameStatus : GameStatus
    }

type MenuStatus
    = Hall
    | Room


type GameStatus
    = Battle


type alias Model =
    { menuStatus : MenuStatus
    , buttonState : Array String
    , delayTime : Int
    , battleInformation : BattleInformation
    , clientList : Array Client
    , client : Client
    , clientName : String
    , gameRoomList : Array GameRoomBasicStatus
    , gameRoom : GameRoom
    , gameRoomName : String
    }

module MainModel exposing (Model)

import Array exposing (Array)
import MenuType
import OnlineBattle1Type
import Type exposing (DisplayIndex, MainModelStatus)



--Model: the model for the whole game


type alias Model =
    { buttonState : Array String
    , display : DisplayIndex
    , mainStatus : MainModelStatus
    , menuModel : MenuType.Model
    , onlineBattle1Model : OnlineBattle1Type.Model
    }

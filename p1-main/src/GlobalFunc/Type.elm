module Type exposing (..)

import Array exposing (Array)
import Time exposing (Posix)



--Pos: position in 2D


type alias Pos =
    ( Float, Float )



--LineSegment: store a line segment, described by two points in 2D


type alias LineSegment =
    ( Pos, Pos )


type alias DisplayIndex =
    { times: Float
    }


--Msg: the global message, activated by individual subscription


type Msg
    = Tick Float
    | KeyUp Int
    | KeyDown Int
    | OnMouseClick Int
    | OnMouseDown Int
    | OnMouseUp Int
    | OnMouseOver Int
    | OnMouseOut Int
    | OnInput Int String
    | ServerMsg String



--CollisionBox: the collision boundary of an object


type CollisionBox
    = Circle
    | Polygon (Array LineSegment)



--IfCollide: whether a collision happens in a single update


type IfCollide
    = Collide
    | NoCollide



--MainModelStatus: what status the whole game is in


type MainModelStatus
    = Menu
    | OnlineBattle1
    
    
type Job
    = AsHost
    | AsClient

type BattleInformation
    = SwitchToOnlineBattle1 Job
    | None
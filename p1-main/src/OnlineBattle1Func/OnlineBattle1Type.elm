module OnlineBattle1Type exposing (..)

import Array exposing (Array)
import Type exposing (CollisionBox, IfCollide, LineSegment, MainModelStatus, Pos)

type AliveStatus
    = Alive
    | DEAD


type Job
    = Host
    | Client


type DelayAction
    = Preparing
    | SwitchToRoom
    | OnePlayerDisconnect

--bricks: bricks that are hit down

type alias Ball =
    { dir : Float
    , pos : Pos
    , collisionBox : CollisionBox
    }

type alias Paddle =
    { dir : Float
    , pos : Pos
    }

type alias Scene =
    { paddleUp : Paddle --used to pend  collisionFrameNum
    , paddleDown : Paddle
    , ball : Ball
    }

type alias Model =
    { job : Job
    , delayTime : Float
    , delayAction : DelayAction
    , pingTime : Int
    , buttonState : Array String
    , upScore : Int
    , downScore : Int
    , scene : Scene
    , frameNum : Int
    , collideFrameNum : Int
    , keyPressed : List Int
    , collideStatus : IfCollide
    , aliveStatus : AliveStatus
    , mainStatus : MainModelStatus
    }
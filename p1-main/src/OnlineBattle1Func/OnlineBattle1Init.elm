module OnlineBattle1Init exposing (..)

import Array
import OnlineBattle1Type exposing (AliveStatus(..), Ball, DelayAction(..), Job(..), Model, Paddle, Scene)
import Type exposing (CollisionBox(..), IfCollide(..), LineSegment, MainModelStatus(..), Pos)
import Constant exposing (..)


--stageSize: width and height of stage


stageSize : Pos
stageSize =
    ( 500.0, 850.0 )

--paddleLength: length of paddle


paddleLength : Float
paddleLength =
    100



--paddleSpeed: speed of paddle moving


paddleMoveSpeed : Float
paddleMoveSpeed =
    3.0

--paddleRotateSpeed: speed of rotation

paddleRotateSpeed : Float
paddleRotateSpeed =
    1


paddleCollideInterval : Int
paddleCollideInterval =
    30


--ballRadius: radius of the ball


ballRadius : Float
ballRadius =
    15.0



--ballSpeed: speed of the ball


ballSpeed : Float
ballSpeed =
    5.0



--timeInterval: the time between each movement


timeInterval : Float
timeInterval =
    0.0



--init: init for OnlineBattle1 model


init : String -> Model
init s =
    Model
        (if s == "Host" then
            Host

        else
            Client
        )
        3000
        Preparing
        0
        ( Array.fromList [ buttonNormalColor, buttonNormalColor, buttonNormalColor, buttonNormalColor ] )
        0
        0
        (Scene
            (Paddle 0 ( 220, 700 ) )
            (Paddle 0 ( 220, 150 ) )
            (Ball (degrees -135) ( 420, 500 ) Circle)
        )
        0
        0
        []
        NoCollide
        Alive
        OnlineBattle1
module OnlineBattle1UpdateHost exposing (updateHost)

import Array
import BasicFunction exposing (clientSend, intListDelete)
import Basics as Basics
import Constant exposing (..)
import Maybe exposing (withDefault)
import OnlineBattle1Collide exposing (updateCollide)
import OnlineBattle1Constant exposing (buttonIDFrom)
import OnlineBattle1Init exposing (ballRadius, ballSpeed, paddleLength, paddleMoveSpeed, paddleRotateSpeed, stageSize)
import OnlineBattle1Type exposing (AliveStatus(..), Ball, DelayAction(..), Job(..), Model, Paddle, Scene)
import OnlineBattle1UpdateClient exposing (updateClient)
import Type exposing (CollisionBox(..), MainModelStatus(..), Msg(..))


updateHost : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateHost msg ( model, cmd ) =
    let
        ( newModel, newCmd ) =
            ( model, Cmd.none )
                |> updateTick msg
                |> updateControl msg
    in
    ( newModel
    , Cmd.batch
        [ newCmd
        , clientSend
            ("hostSendGameStatus"
                ++ " "
                ++ String.fromInt (Basics.round (Tuple.first newModel.scene.ball.pos))
                ++ " "
                ++ String.fromInt (Basics.round (Tuple.second newModel.scene.ball.pos))
                ++ " "
                ++ String.fromInt (Basics.round (Tuple.first newModel.scene.paddleUp.pos))
                ++ " "
                ++ String.fromInt (Basics.round newModel.scene.paddleUp.dir)
                ++ " "
                ++ String.fromInt (Basics.round (Tuple.first newModel.scene.paddleDown.pos))
                ++ " "
                ++ String.fromInt (Basics.round newModel.scene.paddleDown.dir)
                ++ " "
                ++ String.fromInt newModel.upScore
                ++ " "
                ++ String.fromInt newModel.downScore
            )
        ]
    )



--sendControl: call websocket
--port sendControl : String -> Cmd msg
--updateTick: handle Tick message


updateTick : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateTick msg ( model, cmd ) =
    case msg of
        Tick timePassed ->
            if model.delayTime > 0 then
                ( { model | delayTime = model.delayTime - timePassed }, cmd )

            else if model.delayTime /= -1000 then
                case model.delayAction of
                    Preparing ->
                        let
                            moveModel =
                                { model | frameNum = model.frameNum + 1, delayTime = -1000 }
                                    |> movePaddle
                                    |> moveBall

                            ( newModel, newCmd ) =
                                updateCollide ( moveModel, cmd )
                        in
                        ( newModel, newCmd )

                    OnePlayerDisconnect ->
                        ( { model | mainStatus = Menu }, cmd )

                    SwitchToRoom ->
                        ( { model | mainStatus = Menu }, cmd )

            else
                let
                    moveModel =
                        { model | frameNum = model.frameNum + 1, delayTime = -1000 }
                            |> movePaddle
                            |> moveBall

                    ( newModel, newCmd ) =
                        updateCollide ( moveModel, cmd )
                in
                ( newModel, newCmd )

        _ ->
            ( model, cmd )


processHostInputKey : Int -> Int
processHostInputKey inputKeyNum =
    case inputKeyNum of
        38 ->
            87

        40 ->
            83

        37 ->
            65

        39 ->
            68

        otherKeyNum ->
            otherKeyNum


processHostTouchInputKey : Int -> Int
processHostTouchInputKey inputTouchNum =
    case inputTouchNum of
        0 ->
            87

        1 ->
            83

        2 ->
            65

        3 ->
            68

        otherTouchNum ->
            otherTouchNum



--updateControl : handle KeyLeft, KeyRight, KeyNone message


updateControl : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateControl msg ( model, cmd ) =
    let
        oldKeyPressed =
            model.keyPressed
    in
    case msg of
        OnMouseOver num ->
            --( { model | buttonState = Array.set (num - buttonIDFrom) buttonOverColor model.buttonState }
            --, Cmd.batch [ cmd ]
            --)
            let
                ( newModel, newCmd ) =
                    if 0 <= num - buttonIDFrom && num - buttonIDFrom <= 3 then
                        ( { model | keyPressed = List.append [ processHostTouchInputKey (num - buttonIDFrom) ] oldKeyPressed }, cmd )

                    else
                        ( model, cmd )
            in
            ( { newModel | buttonState = Array.set (num - buttonIDFrom) buttonDownColor newModel.buttonState }
            , Cmd.batch [ newCmd ]
            )

        OnMouseOut num ->
            --( { model | buttonState = Array.set (num - buttonIDFrom) buttonNormalColor model.buttonState }
            --, Cmd.batch [ cmd ]
            --)
            let
                ( newModel, newCmd ) =
                    if 0 <= num - buttonIDFrom && num - buttonIDFrom <= 3 then
                        ( { model | keyPressed = intListDelete (processHostTouchInputKey (num - buttonIDFrom)) oldKeyPressed }, cmd )

                    else
                        ( model, cmd )
            in
            ( { newModel | buttonState = Array.set (num - buttonIDFrom) buttonNormalColor newModel.buttonState }
            , Cmd.batch [ newCmd ]
            )

        OnMouseDown num ->
            let
                ( newModel, newCmd ) =
                    if 0 <= num - buttonIDFrom && num - buttonIDFrom <= 3 then
                        ( { model | keyPressed = List.append [ processHostTouchInputKey (num - buttonIDFrom) ] oldKeyPressed }, cmd )

                    else
                        ( model, cmd )
            in
            ( { newModel | buttonState = Array.set (num - buttonIDFrom) buttonDownColor newModel.buttonState }
            , Cmd.batch [ newCmd ]
            )

        OnMouseUp num ->
            let
                ( newModel, newCmd ) =
                    if 0 <= num - buttonIDFrom && num - buttonIDFrom <= 3 then
                        ( { model | keyPressed = intListDelete (processHostTouchInputKey (num - buttonIDFrom)) oldKeyPressed }, cmd )

                    else
                        ( model, cmd )
            in
            ( { newModel | buttonState = Array.set (num - buttonIDFrom) buttonNormalColor newModel.buttonState }
            , Cmd.batch [ newCmd ]
            )

        KeyUp inputKeyNum ->
            ( { model | keyPressed = intListDelete (processHostInputKey inputKeyNum) oldKeyPressed }, cmd )

        KeyDown inputKeyNum ->
            ( { model | keyPressed = List.append [ processHostInputKey inputKeyNum ] oldKeyPressed }, cmd )

        ServerMsg serverMsg ->
            let
                splitServerMsg =
                    Array.fromList (String.split " " serverMsg)
            in
            case withDefault "" (Array.get 0 splitServerMsg) of
                "clientControlStatusToHost" ->
                    case withDefault "" (Array.get 1 splitServerMsg) of
                        "KeyUp" ->
                            ( { model
                                | keyPressed =
                                    intListDelete (withDefault 0 (String.toInt (withDefault "" (Array.get 2 splitServerMsg)))) oldKeyPressed
                              }
                            , cmd
                            )

                        "KeyDown" ->
                            ( { model
                                | keyPressed =
                                    List.append [ withDefault 0 (String.toInt (withDefault "" (Array.get 2 splitServerMsg))) ] oldKeyPressed
                              }
                            , cmd
                            )

                        _ ->
                            ( model, Cmd.batch [ cmd ] )

                "ping" ->
                    let
                        pingTime =
                            withDefault 999 (String.toInt (withDefault "999" (Array.get 1 splitServerMsg)))
                    in
                    ( { model | pingTime = pingTime }, Cmd.none )

                "gameClose" ->
                    let
                        reason =
                            withDefault "" (Array.get 1 splitServerMsg)
                    in
                    case reason of
                        "onePlayerDisconnect" ->
                            ( { model | delayTime = 3000, delayAction = OnePlayerDisconnect }, cmd )

                        "switchToRoom" ->
                            ( { model | delayTime = 3000, delayAction = SwitchToRoom }, cmd )

                        _ ->
                            ( model, Cmd.batch [ cmd ] )

                _ ->
                    ( model, Cmd.batch [ cmd ] )

        _ ->
            ( model, cmd )



--movePaddle: move paddle


movePaddle : Model -> Model
movePaddle model =
    let
        modelLeftRightUp =
            if List.member 37 model.keyPressed then
                if List.member 39 model.keyPressed then
                    model

                else
                    let
                        newPaddle =
                            Paddle
                                model.scene.paddleUp.dir
                                ( Basics.max (paddleLength / 2) (Tuple.first model.scene.paddleUp.pos - paddleMoveSpeed), Tuple.second model.scene.paddleUp.pos )

                        --model.scene.paddleUp.collisionFrameNum
                        oldScene =
                            model.scene

                        newScene =
                            { oldScene | paddleUp = newPaddle }
                    in
                    { model | scene = newScene }

            else if List.member 39 model.keyPressed then
                let
                    newPaddle =
                        Paddle
                            model.scene.paddleUp.dir
                            ( Basics.min (Tuple.first stageSize - paddleLength / 2) (Tuple.first model.scene.paddleUp.pos + paddleMoveSpeed), Tuple.second model.scene.paddleUp.pos )

                    --model.scene.paddleUp.collisionFrameNum
                    oldScene =
                        model.scene

                    newScene =
                        { oldScene | paddleUp = newPaddle }
                in
                { model | scene = newScene }

            else
                model

        modelLeftRight =
            if List.member 65 modelLeftRightUp.keyPressed then
                if List.member 68 modelLeftRightUp.keyPressed then
                    modelLeftRightUp

                else
                    let
                        newPaddle =
                            Paddle
                                modelLeftRightUp.scene.paddleDown.dir
                                ( Basics.max (paddleLength / 2) (Tuple.first modelLeftRightUp.scene.paddleDown.pos - paddleMoveSpeed), Tuple.second modelLeftRightUp.scene.paddleDown.pos )

                        --modelLeftRightUp.scene.paddleDown.collisionFrameNum
                        oldScene =
                            modelLeftRightUp.scene

                        newScene =
                            { oldScene | paddleDown = newPaddle }
                    in
                    { modelLeftRightUp | scene = newScene }

            else if List.member 68 modelLeftRightUp.keyPressed then
                let
                    newPaddle =
                        Paddle
                            modelLeftRightUp.scene.paddleDown.dir
                            ( Basics.min (Tuple.first stageSize - paddleLength / 2) (Tuple.first modelLeftRightUp.scene.paddleDown.pos + paddleMoveSpeed), Tuple.second modelLeftRightUp.scene.paddleDown.pos )

                    --modelLeftRightUp.scene.paddleDown.collisionFrameNum
                    oldScene =
                        modelLeftRightUp.scene

                    newScene =
                        { oldScene | paddleDown = newPaddle }
                in
                { modelLeftRightUp | scene = newScene }

            else
                modelLeftRightUp

        modelUpDownUp =
            if List.member 38 modelLeftRight.keyPressed then
                if List.member 40 modelLeftRight.keyPressed then
                    modelLeftRight

                else
                    let
                        newPaddle =
                            Paddle
                                (Basics.min ( 85 ) (modelLeftRight.scene.paddleUp.dir + paddleRotateSpeed))
                                ( Tuple.first modelLeftRight.scene.paddleUp.pos, Tuple.second modelLeftRight.scene.paddleUp.pos )

                        --modelLeftRight.scene.paddleUp.collisionFrameNum
                        oldScene =
                            modelLeftRight.scene

                        newScene =
                            { oldScene | paddleUp = newPaddle }
                    in
                    { modelLeftRight | scene = newScene }

            else if List.member 40 modelLeftRight.keyPressed then
                let
                    newPaddle =
                        Paddle
                            (Basics.max ( -85 )
                                (modelLeftRight.scene.paddleUp.dir - paddleRotateSpeed)
                            )
                            ( Tuple.first modelLeftRight.scene.paddleUp.pos, Tuple.second modelLeftRight.scene.paddleUp.pos )

                    --modelLeftRight.scene.paddleUp.collisionFrameNum
                    oldScene =
                        modelLeftRight.scene

                    newScene =
                        { oldScene | paddleUp = newPaddle }
                in
                { modelLeftRight | scene = newScene }

            else
                modelLeftRight

        modelUpDown =
            if List.member 87 modelUpDownUp.keyPressed then
                if List.member 83 modelUpDownUp.keyPressed then
                    modelUpDownUp

                else
                    let
                        newPaddle =
                            Paddle
                                (Basics.min ( 85 ) (modelUpDownUp.scene.paddleDown.dir + paddleRotateSpeed))
                                ( Tuple.first modelUpDownUp.scene.paddleDown.pos, Tuple.second modelUpDownUp.scene.paddleDown.pos )

                        --modelUpDownUp.scene.paddleDown.collisionFrameNum
                        oldScene =
                            modelUpDownUp.scene

                        newScene =
                            { oldScene | paddleDown = newPaddle }
                    in
                    { modelUpDownUp | scene = newScene }

            else if List.member 83 modelUpDownUp.keyPressed then
                let
                    newPaddle =
                        Paddle
                            (Basics.max ( -85 )
                                (modelUpDownUp.scene.paddleDown.dir - paddleRotateSpeed)
                            )
                            ( Tuple.first modelUpDownUp.scene.paddleDown.pos, Tuple.second modelUpDownUp.scene.paddleDown.pos )

                    --modelUpDownUp.scene.paddleDown.collisionFrameNum
                    oldScene =
                        modelUpDownUp.scene

                    newScene =
                        { oldScene | paddleDown = newPaddle }
                in
                { modelUpDownUp | scene = newScene }

            else
                modelUpDownUp
    in
    modelUpDown


moveBall : Model -> Model
moveBall model =
    let
        oldX =
            Tuple.first model.scene.ball.pos

        oldY =
            Tuple.second model.scene.ball.pos

        newX =
            Basics.min (Basics.max (ballRadius - 0.1) oldX + ballSpeed * Basics.cos model.scene.ball.dir) (Tuple.first stageSize + ballRadius - 0.1)

        newY =
            Basics.min (Basics.max (ballRadius - 0.1) oldY + ballSpeed * Basics.sin model.scene.ball.dir) (Tuple.second stageSize + ballRadius - 0.1)

        newBall =
            Ball model.scene.ball.dir ( newX, newY ) model.scene.ball.collisionBox

        oldScene =
            model.scene

        newScene =
            { oldScene | ball = newBall }
    in
    { model | scene = newScene }

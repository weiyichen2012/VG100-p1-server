module OnlineBattle1UpdateClient exposing (updateClient)

import Array
import BasicFunction exposing (clientSend)
import Constant exposing (..)
import Maybe exposing (withDefault)
import OnlineBattle1Constant exposing (buttonIDFrom)
import OnlineBattle1Type exposing (AliveStatus(..), Ball, DelayAction(..), Job(..), Model, Paddle, Scene)
import Type exposing (CollisionBox(..), MainModelStatus(..), Msg(..))


updateClient : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateClient msg ( model, cmd ) =
    case msg of
        Tick timePassed ->
            if model.delayTime > 0 then
                ( { model | delayTime = model.delayTime - timePassed }, Cmd.none )

            else if model.delayTime /= -1000 then
                case model.delayAction of
                    Preparing ->
                        ( { model | delayTime = -1000 }, Cmd.none )

                    SwitchToRoom ->
                        ( { model | mainStatus = Menu }, Cmd.none )

                    OnePlayerDisconnect ->
                        ( { model | mainStatus = Menu }, Cmd.none )

            else
                ( model, Cmd.none )

        ServerMsg serverMsg ->
            let
                splitServerMsg =
                    Array.fromList (String.split " " serverMsg)
            in
            case withDefault "" (Array.get 0 splitServerMsg) of
                "hostGameStatusToClient" ->
                    let
                        ballX =
                            withDefault 0.0 (String.toFloat (withDefault "" (Array.get 1 splitServerMsg)))

                        ballY =
                            withDefault 0.0 (String.toFloat (withDefault "" (Array.get 2 splitServerMsg)))

                        paddleUpX =
                            withDefault 0.0 (String.toFloat (withDefault "" (Array.get 3 splitServerMsg)))

                        paddleUpDir =
                            withDefault 0.0 (String.toFloat (withDefault "" (Array.get 4 splitServerMsg)))

                        paddleDownX =
                            withDefault 0.0 (String.toFloat (withDefault "" (Array.get 5 splitServerMsg)))

                        paddleDownDir =
                            withDefault 0.0 (String.toFloat (withDefault "" (Array.get 6 splitServerMsg)))

                        upScore =
                            withDefault 0 (String.toInt (withDefault "" (Array.get 7 splitServerMsg)))

                        downScore =
                            withDefault 0 (String.toInt (withDefault "" (Array.get 8 splitServerMsg)))

                        newBall =
                            Ball 0 ( ballX, ballY ) Circle

                        oldPaddleUp =
                            model.scene.paddleUp

                        newPaddleUp =
                            Paddle paddleUpDir ( paddleUpX, Tuple.second oldPaddleUp.pos )

                        oldPaddleDown =
                            model.scene.paddleDown

                        newPaddleDown =
                            Paddle paddleDownDir ( paddleDownX, Tuple.second oldPaddleDown.pos )

                        newScene =
                            Scene newPaddleUp newPaddleDown newBall
                    in
                    ( { model | scene = newScene, upScore = upScore, downScore = downScore }, Cmd.none )

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
                            ( { model | delayTime = 3000, delayAction = OnePlayerDisconnect }, Cmd.none )

                        "switchToRoom" ->
                            ( { model | delayTime = 3000, delayAction = SwitchToRoom }, Cmd.none )

                        _ ->
                            ( model, Cmd.batch [ cmd ] )

                _ ->
                    ( model, Cmd.batch [ cmd ] )

        KeyUp inputKeyNum ->
            ( model
            , Cmd.batch
                [ clientSend
                    ("clientSendControlStatus"
                        ++ " "
                        ++ "KeyUp"
                        ++ " "
                        ++ String.fromInt (processClientInputKey inputKeyNum)
                    )
                ]
            )

        KeyDown inputKeyNum ->
            ( model
            , Cmd.batch
                [ clientSend
                    ("clientSendControlStatus"
                        ++ " "
                        ++ "KeyDown"
                        ++ " "
                        ++ String.fromInt (processClientInputKey inputKeyNum)
                    )
                ]
            )

        OnMouseOver num ->
            let
                ( newModel, newCmd ) =
                    if 0 <= num - buttonIDFrom && num - buttonIDFrom <= 3 then
                        ( { model | keyPressed = List.append [ processClientTouchKey (num - buttonIDFrom) ] model.keyPressed }
                        , Cmd.batch
                            [ clientSend
                                ("clientSendControlStatus"
                                    ++ " "
                                    ++ "KeyDown"
                                    ++ " "
                                    ++ String.fromInt (processClientTouchKey (num - buttonIDFrom))
                                )
                            ]
                        )

                    else
                        ( model, cmd )
            in
            ( { newModel | buttonState = Array.set (num - buttonIDFrom) buttonDownColor newModel.buttonState }
            , Cmd.batch [ newCmd ]
            )

        OnMouseOut num ->
            let
                ( newModel, newCmd ) =
                    if 0 <= num - buttonIDFrom && num - buttonIDFrom <= 3 then
                        ( { model | buttonState = Array.set (num - buttonIDFrom) buttonNormalColor model.buttonState }
                            , Cmd.batch
                                [ clientSend
                                    ("clientSendControlStatus"
                                        ++ " "
                                        ++ "KeyUp"
                                        ++ " "
                                        ++ String.fromInt (processClientTouchKey (num - buttonIDFrom))
                                    )
                                ]
                            )

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
                        ( { model | keyPressed = List.append [ processClientTouchKey (num - buttonIDFrom) ] model.keyPressed }
                        , Cmd.batch
                            [ clientSend
                                ("clientSendControlStatus"
                                    ++ " "
                                    ++ "KeyDown"
                                    ++ " "
                                    ++ String.fromInt (processClientTouchKey (num - buttonIDFrom))
                                )
                            ]
                        )

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
                        ( { model | buttonState = Array.set (num - buttonIDFrom) buttonNormalColor model.buttonState }
                            , Cmd.batch
                                [ clientSend
                                    ("clientSendControlStatus"
                                        ++ " "
                                        ++ "KeyUp"
                                        ++ " "
                                        ++ String.fromInt (processClientTouchKey (num - buttonIDFrom))
                                    )
                                ]
                            )

                    else
                        ( model, cmd )
            in
            ( { newModel | buttonState = Array.set (num - buttonIDFrom) buttonNormalColor newModel.buttonState }
            , Cmd.batch [ newCmd ]
            )

        _ ->
            ( model, Cmd.none )


processClientInputKey : Int -> Int
processClientInputKey inputKeyNum =
    case inputKeyNum of
        87 ->
            38

        83 ->
            40

        65 ->
            37

        68 ->
            39

        otherKeyNum ->
            otherKeyNum


processClientTouchKey : Int -> Int
processClientTouchKey inputTouchNum =
    case inputTouchNum of
        0 ->
            38

        1 ->
            40

        2 ->
            37

        3 ->
            39

        otherTouchNum ->
            otherTouchNum

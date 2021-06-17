module MenuUpdate exposing (update)

import Array
import BasicFunction exposing (clientSend)
import Constant exposing (..)
import Maybe exposing (withDefault)
import MenuConstant exposing (..)
import MenuType exposing (Client, GameRoom, GameRoomBasicStatus, GameStatus(..), MenuStatus(..), Model)
import Type exposing (BattleInformation(..), Job(..), MainModelStatus(..), Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
        |> updateServerMsg msg
        |> updateButton msg


updateButton : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateButton msg ( model, cmd ) =
    case msg of
        OnMouseOver num ->
            ( { model | buttonState = Array.set (num - buttonIdFrom) buttonOverColor model.buttonState }
            , Cmd.batch [ cmd ]
              --, cmd
            )

        OnMouseOut num ->
            ( { model | buttonState = Array.set (num - buttonIdFrom) buttonNormalColor model.buttonState }
            , Cmd.batch [ cmd ]
              --, cmd
            )

        OnMouseDown num ->
            ( { model | buttonState = Array.set (num - buttonIdFrom) buttonDownColor model.buttonState }
            , Cmd.batch [ cmd ]
              --, cmd
            )

        OnMouseUp num ->
            let
                ( newModel, newCmd ) =
                    if joinRoomButtonStartId <= num && num <= joinRoomButtonEndId then
                        ( model, Cmd.batch [ cmd,  clientSend ("joinRoom " ++ String.fromInt (num - joinRoomButtonStartId)) ] )

                    else
                        case num of
                            0 ->
                                --createRoomButtonId
                                ( model, Cmd.batch [ cmd, clientSend "createRoom" ] )

                            1 ->
                                --refreshHallButtonId
                                ( model, Cmd.batch [ cmd, clientSend "refreshHall" ] )

                            3 ->
                                --confirmClientNameButtonId
                                ( model, Cmd.batch [ cmd, clientSend ("changeClient ~" ++ model.clientName ++ "~") ] )

                            4 ->
                                --refreshRoomButtonId
                                ( model, Cmd.batch [ cmd, clientSend "refreshRoom" ] )

                            6 ->
                                --confirmRoomNameButtonId
                                ( model, Cmd.batch [ cmd, clientSend ("changeRoom ~" ++ model.gameRoomName ++ "~") ] )

                            38 ->
                                --quitRoom
                                ( model, Cmd.batch [ cmd, clientSend ("quitRoom") ] )

                            39 ->
                                --startRoomGameButtonId =
                                ( model, Cmd.batch [ cmd, clientSend ("startRoomGame") ] )

                            _ ->
                                ( model, Cmd.batch [ cmd ] )
            in
            ( { newModel | buttonState = Array.set (num - buttonIdFrom) buttonNormalColor newModel.buttonState }
            , Cmd.batch [ newCmd ]
            )

        --else
        --    ( { newModel | buttonState = Array.set (num - buttonIdFrom) buttonNormalColor newModel.buttonState }
        --    , Cmd.batch [ newCmd ]
        --    )
        OnInput num input ->
            case num of
                2 ->
                    --ownClientNameTextBoxId
                    ( { model | clientName = input }, Cmd.batch [ cmd ] )

                5 ->
                    --ownRoomNameTextBoxId
                    ( { model | gameRoomName = input }, Cmd.batch [ cmd ] )

                number ->
                    ( model
                    , Cmd.batch [ cmd ]
                    )

        _ ->
            ( model, cmd )


updateServerMsg : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateServerMsg msg ( model, cmd ) =
    case msg of
        ServerMsg serverMsg ->
            let
                splitServerMsg =
                    Array.fromList (String.split " " serverMsg)
            in
            case withDefault "" (Array.get 0 splitServerMsg) of
                "changeClientStatus" ->
                    let
                        newClient =
                            Client
                                (withDefault "" (Array.get 1 splitServerMsg))
                                (withDefault "" (Array.get 2 splitServerMsg))
                                (withDefault "" (Array.get 3 splitServerMsg))
                    in
                    ( { model | client = newClient }, Cmd.batch [ cmd ] )

                "refreshHallStatus" ->
                    let
                        clientsNum =
                            withDefault 0 (String.toInt (withDefault "0" (Array.get 1 splitServerMsg)))

                        newClientList =
                            Array.fromList
                                (List.map
                                    (\i ->
                                        Client
                                            (withDefault "" (Array.get (3 * (i + 1) - 1) splitServerMsg))
                                            (withDefault "" (Array.get (3 * (i + 1)) splitServerMsg))
                                            (withDefault "" (Array.get (3 * (i + 1) + 1) splitServerMsg))
                                    )
                                    (List.range 0 (clientsNum - 1))
                                )

                        gameRoomStartPos =
                            3 * clientsNum + 2

                        gameRoomNum =
                            withDefault 0 (String.toInt (withDefault "0" (Array.get gameRoomStartPos splitServerMsg)))

                        newGameRoomList =
                            Array.fromList
                                (List.map
                                    (\i ->
                                        GameRoomBasicStatus
                                            (withDefault "" (Array.get (3 * i + gameRoomStartPos + 1) splitServerMsg))
                                            (withDefault "" (Array.get (3 * i + gameRoomStartPos + 2) splitServerMsg))
                                            (withDefault 0 (String.toInt (withDefault "" (Array.get (3 * i + gameRoomStartPos + 3) splitServerMsg))))
                                            Battle
                                    )
                                    (List.range 0 (gameRoomNum - 1))
                                )
                    in
                    if withDefault "" (Array.get (3 * (gameRoomNum - 1) + gameRoomStartPos + 4) splitServerMsg) == "force" then
                        ( { model | clientList = newClientList, gameRoomList = newGameRoomList, menuStatus = Hall }, Cmd.batch [ cmd ] )

                    else
                        ( { model | clientList = newClientList, gameRoomList = newGameRoomList }, Cmd.batch [ cmd ] )

                "refreshRoomStatus" ->
                    let
                        newRoomUUID =
                            withDefault "" (Array.get 1 splitServerMsg)

                        newRoomName =
                            withDefault "" (Array.get 2 splitServerMsg)

                        newClientsNum =
                            withDefault 1 (String.toInt (withDefault "0" (Array.get 3 splitServerMsg)))

                        newClientList =
                            Array.fromList
                                (List.map
                                    (\i ->
                                        Client
                                            (withDefault "" (Array.get (3 * (i + 1) + 1) splitServerMsg))
                                            (withDefault "" (Array.get (3 * (i + 1) + 2) splitServerMsg))
                                            (withDefault "" (Array.get (3 * (i + 1) + 3) splitServerMsg))
                                    )
                                    (List.range 0 (newClientsNum - 1))
                                )

                        newRoom =
                            GameRoom newRoomUUID newRoomName newClientList Battle
                    in
                    if withDefault "" (Array.get (3 * newClientsNum + 4) splitServerMsg) == "force" then
                        ( { model | menuStatus = Room, gameRoom = newRoom }, Cmd.batch [ cmd ] )

                    else
                        ( { model | gameRoom = newRoom }, Cmd.batch [ cmd ] )

                "ping" ->
                    let
                        delayTime =
                            withDefault 999 (String.toInt (withDefault "999" (Array.get 1 splitServerMsg)))
                    in
                        ( { model | delayTime = delayTime }, Cmd.batch [ cmd ] )

                "startRoomGameStatus" ->
                    if withDefault "" (Array.get 1 splitServerMsg) == "Host" then
                        case model.gameRoom.gameStatus of
                            Battle ->
                                ( { model | battleInformation = (SwitchToOnlineBattle1 AsHost) }, Cmd.batch [ cmd ])

                    else
                        case model.gameRoom.gameStatus of
                            Battle ->
                                ( { model | battleInformation = (SwitchToOnlineBattle1 AsClient) }, Cmd.batch [ cmd ])


                _ ->
                    ( model, Cmd.batch [ cmd ] )

        _ ->
            ( model, cmd )

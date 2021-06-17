module HallView exposing (view)

import Array
import BasicFunction exposing (defaultBoundaries, viewStringMulX, viewStringMulY)
import Constant exposing (buttonDownColor, windowSize)
import Html exposing (Html, div, input)
import Html.Attributes as HtmlAttr
import Html.Events as HtmlEvents
import MainModel
import Maybe exposing (withDefault)
import MenuConstant exposing (..)
import MenuType exposing (Client, GameRoomBasicStatus, GameStatus(..), MenuStatus(..), Model)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import Type exposing (Msg(..))
import BasicFunction exposing (viewToggleButton)

view : MainModel.Model -> Html Msg
view mainModel =
    let
        model =
            mainModel.menuModel
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "50"
        , HtmlAttr.style "top" "50"
        ]
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            (defaultBoundaries mainModel Constant.windowSize
                ++ drawHallMenu mainModel model
                ++ drawHallButtons mainModel model
                ++ listHallClients mainModel model
                ++ listHallGameRooms mainModel model
                ++ viewToggleButton mainModel
            )

        --, Svg.rect
        --    [ SvgAttr.x ( viewStringMulX"100"
        --    , SvgAttr.y ( viewStringMul "100"
        --    , SvgAttr.width "100"
        --    , SvgAttr.height "200"
        --    , SvgAttr.fill model.color
        --    , SvgEvent.onMouseOver (OnMouseOver 12)
        --    , SvgEvent.onMouseOut (OnMouseOut 12)
        --    ][]
        ]


drawHallMenu : MainModel.Model -> Model -> List (Svg Msg)
drawHallMenu mainModel model =
    [ Svg.rect
        [ SvgAttr.x ( viewStringMulX mainModel"0" )
        , SvgAttr.y ( viewStringMulY mainModel"0"  )
        , SvgAttr.width ( viewStringMulY mainModel(String.fromFloat (Tuple.first windowSize)))
        , SvgAttr.height ( viewStringMulY mainModel(String.fromFloat (Tuple.second windowSize)))
        , SvgAttr.fill "#F9F9F9"
        ]
        []
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"800" )
        , SvgAttr.y ( viewStringMulY mainModel"50"  )
        , SvgAttr.fontSize ( viewStringMulY mainModel"20" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text ( "Ping: " ++ String.fromInt model.delayTime ++ "ms" ) ]
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"500" )
        , SvgAttr.y ( viewStringMulY mainModel"50"  )
        , SvgAttr.fontSize ( viewStringMulY mainModel"50" )
        , SvgAttr.textAnchor "middle"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "Game Hall" ]
    , Svg.line
        [ SvgAttr.x1 ( viewStringMulX mainModel"50" )
        , SvgAttr.y1 ( viewStringMulY mainModel "100" )
        , SvgAttr.x2 ( viewStringMulX mainModel "1000" )
        , SvgAttr.y2 ( viewStringMulY mainModel "100" )
        , SvgAttr.stroke "#000000"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 ( viewStringMulX mainModel"600" )
        , SvgAttr.y1 ( viewStringMulY mainModel "100" )
        , SvgAttr.x2 ( viewStringMulX mainModel "600" )
        , SvgAttr.y2 ( viewStringMulY mainModel "850" )
        , SvgAttr.stroke "#000000"
        ]
        []
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"100" )
        , SvgAttr.y ( viewStringMulY mainModel"150"  )
        , SvgAttr.fontSize ( viewStringMulY mainModel"50" )
        , SvgAttr.textAnchor "middle"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "Rooms" ]
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"800" )
        , SvgAttr.y ( viewStringMulY mainModel"150"  )
        , SvgAttr.fontSize ( viewStringMulY mainModel"50" )
        , SvgAttr.textAnchor "middle"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "Online Players" ]
    ]


drawHallButtons : MainModel.Model -> Model -> List (Svg Msg)
drawHallButtons mainModel model =
    -- create room
    [ Svg.rect
        [ SvgAttr.x ( viewStringMulX mainModel"20" )
        , SvgAttr.y ( viewStringMulY mainModel"750"  )
        , SvgAttr.width ( viewStringMulY mainModel"200" )
        , SvgAttr.height ( viewStringMulY mainModel"80" )
        , SvgAttr.fill (withDefault "Black" (Array.get createRoomButtonId model.buttonState))
        ]
        []
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"30" )
        , SvgAttr.y ( viewStringMulY mainModel"795"  )
        , SvgAttr.fontSize ( viewStringMulY mainModel"30" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "create room" ]
    , Svg.rect
        [ SvgAttr.x ( viewStringMulX mainModel"20" )
        , SvgAttr.y ( viewStringMulY mainModel"750"  )
        , SvgAttr.width ( viewStringMulY mainModel"200" )
        , SvgAttr.height ( viewStringMulY mainModel"80" )
        , SvgAttr.fill "#00000000"
        , SvgEvent.onMouseOver (OnMouseOver createRoomButtonId)
        , SvgEvent.onMouseOut (OnMouseOut createRoomButtonId)
        , SvgEvent.onMouseDown (OnMouseDown createRoomButtonId)
        , SvgEvent.onMouseUp (OnMouseUp createRoomButtonId)
        ]
        []

    --confirm (change name)
    , Svg.rect
        [ SvgAttr.x ( viewStringMulX mainModel"1087" )
        , SvgAttr.y ( viewStringMulY mainModel"160"  )
        , SvgAttr.width ( viewStringMulY mainModel"100" )
        , SvgAttr.height ( viewStringMulY mainModel"60" )
        , SvgAttr.fill (withDefault "Black" (Array.get confirmOwnClientNameButtonId model.buttonState))
        ]
        []
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"1100" )
        , SvgAttr.y ( viewStringMulY mainModel"196"  )
        , SvgAttr.fontSize ( viewStringMulY mainModel"20" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "confirm" ]
    , Svg.rect
        [ SvgAttr.x ( viewStringMulX mainModel"1087" )
        , SvgAttr.y ( viewStringMulY mainModel"160"  )
        , SvgAttr.width ( viewStringMulY mainModel"100" )
        , SvgAttr.height ( viewStringMulY mainModel"60" )
        , SvgAttr.fill "#00000000"
        , SvgEvent.onMouseOver (OnMouseOver confirmOwnClientNameButtonId)
        , SvgEvent.onMouseOut (OnMouseOut confirmOwnClientNameButtonId)
        , SvgEvent.onMouseDown (OnMouseDown confirmOwnClientNameButtonId)
        , SvgEvent.onMouseUp (OnMouseUp confirmOwnClientNameButtonId)
        ]
        []

    -- input name
    , Svg.foreignObject
        [ SvgAttr.x ( viewStringMulX mainModel"900" )
        , SvgAttr.y ( viewStringMulY mainModel"190"  )
        --, SvgAttr.width "160"
        , SvgAttr.width ( viewStringMulY mainModel"140" )
        , SvgAttr.height ( viewStringMulY mainModel"80" )
        --, SvgAttr.height "50"
        , SvgAttr.fill "#00FF00"
        ]
        [ input
            [ HtmlAttr.size 10
            , HtmlAttr.type_ "text"
            --, HtmlAttr.value "yourName"
            , HtmlAttr.maxlength 10
            , HtmlEvents.onInput (OnInput ownClientNameTextBoxId)
            ]
            []
        ]

    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"900" )
        , SvgAttr.y ( viewStringMulY mainModel"180"  )
        , SvgAttr.fontSize ( viewStringMulY mainModel"20" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "input your name" ]
    ]


listHallClients : MainModel.Model -> Model -> List (Svg Msg)
listHallClients mainModel model =
    [ Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"700" )
        , SvgAttr.y ( viewStringMulY mainModel"200" )
        , SvgAttr.fontSize ( viewStringMulY mainModel"30" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text ("Numbers: " ++ String.fromInt (Array.length model.clientList)) ]
    ]
        ++ List.map (\i -> listHallClient mainModel model i (withDefault defaultClient (Array.get i model.clientList))) (List.range 0 (Array.length model.clientList - 1))


listHallClient : MainModel.Model -> Model -> Int -> Client -> Svg Msg
listHallClient mainModel model l client =
    Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"630" )
        , SvgAttr.y ( viewStringMulY mainModel(String.fromInt (250 + 50 * l)) )
        , SvgAttr.fontSize ( viewStringMulY mainModel"25" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ if client.uuid == model.client.uuid then
            Svg.text (client.name ++ "(you)")

          else
            Svg.text client.name
        ]


listHallGameRooms : MainModel.Model -> Model -> List (Svg Msg)
listHallGameRooms mainModel model =
    List.map
        (\i -> listHallGameRoom mainModel model i (withDefault defaultGameRoomBasicStatus (Array.get i model.gameRoomList)))
        (List.range 0 (Array.length model.gameRoomList - 1))
        |> List.concat


listHallGameRoom : MainModel.Model -> Model -> Int -> GameRoomBasicStatus -> List (Svg Msg)
listHallGameRoom mainModel model l gameRoomBasicStatus =
    [ Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"25" )
        , SvgAttr.y ( viewStringMulY mainModel(String.fromInt (210 + 100 * l)) )
        , SvgAttr.fontSize ( viewStringMulY mainModel"25" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ case gameRoomBasicStatus.gameStatus of
            Battle ->
                Svg.text (gameRoomBasicStatus.name ++ " (" ++ String.fromInt gameRoomBasicStatus.playerNum ++ "/2)")
        ]
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"25" )
        , SvgAttr.y ( viewStringMulY mainModel(String.fromInt (250 + 100 * l)) )
        , SvgAttr.fontSize ( viewStringMulY mainModel"25" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ case gameRoomBasicStatus.gameStatus of
            Battle ->
                Svg.text "Type: Battle"
        ]
    --joinRoomButton
    , Svg.rect
        [ SvgAttr.x ( viewStringMulX mainModel"425" )
        , SvgAttr.y ( viewStringMulY mainModel(String.fromInt (190 + 100 * l)) )
        , SvgAttr.width ( viewStringMulY mainModel"150" )
        , SvgAttr.height ( viewStringMulY mainModel"60" )
        , SvgAttr.fill
            (case gameRoomBasicStatus.gameStatus of
                Battle ->
                    if gameRoomBasicStatus.playerNum == 2 then
                        buttonDownColor

                    else
                        (withDefault "Black" (Array.get (joinRoomButtonStartId + l) model.buttonState))
            )
        ]
        []
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel"455" )
        , SvgAttr.y ( viewStringMulY mainModel(String.fromInt (225 + 100 * l)) )
        , SvgAttr.fontSize ( viewStringMulY mainModel"20" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text
            ( if gameRoomBasicStatus.playerNum == 2 then
                "room full"

              else
                "join room"
            )
        ]
    , Svg.rect
        ( List.append
            [ SvgAttr.x ( viewStringMulX mainModel"425" )
            , SvgAttr.y ( viewStringMulY mainModel(String.fromInt (190 + 100 * l)) )
            , SvgAttr.width ( viewStringMulY mainModel"150" )
            , SvgAttr.height ( viewStringMulY mainModel"60" )
            , SvgAttr.fill "#00000000"
            ]
            ( if gameRoomBasicStatus.playerNum == 2 then
                []

              else
                [ SvgEvent.onMouseOver (OnMouseOver (joinRoomButtonStartId + l))
                , SvgEvent.onMouseOut (OnMouseOut (joinRoomButtonStartId + l))
                , SvgEvent.onMouseDown (OnMouseDown (joinRoomButtonStartId + l))
                , SvgEvent.onMouseUp (OnMouseUp (joinRoomButtonStartId + l))]
            )
        )
        []
    ]

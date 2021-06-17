module RoomView exposing (..)

import Array exposing (Array)
import BasicFunction exposing (defaultBoundaries, viewStringMulX, viewStringMulY)
import Constant exposing (buttonDownColor, windowSize)
import Html exposing (Html, div, input)
import Html.Attributes as HtmlAttr
import Html.Events as HtmlEvents
import MainModel
import Maybe exposing (withDefault)
import MenuConstant exposing (..)
import MenuType exposing (Client, GameStatus(..), MenuStatus(..), Model)
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
                ++ drawRoomMenu mainModel model
                ++ drawRoomClientList mainModel model
                ++ drawRoomButton mainModel model
                ++ viewToggleButton mainModel
            )

        --, Svg.rect
        --    [ SvgAttr.x ( viewStringMulX mainModel "100"
        --    , SvgAttr.y ( viewStringMulY mainModel "100"
        --    , SvgAttr.width ( viewStringMulY mainModel "100"
        --    , SvgAttr.height ( viewStringMulY mainModel "200"
        --    , SvgAttr.fill model.color
        --    , SvgEvent.onMouseOver (OnMouseOver 12)
        --    , SvgEvent.onMouseOut (OnMouseOut 12)
        --    ][]
        ]


drawRoomMenu : MainModel.Model -> Model -> List (Svg Msg)
drawRoomMenu mainModel model =
    [ Svg.rect
        [ SvgAttr.x ( viewStringMulX mainModel "0" )
        , SvgAttr.y ( viewStringMulY mainModel "0" )
        , SvgAttr.width ( viewStringMulY mainModel (String.fromFloat (Tuple.first windowSize)) )
        , SvgAttr.height ( viewStringMulY mainModel (String.fromFloat (Tuple.second windowSize)) )
        , SvgAttr.fill "#F9F9F9"
        ]
        []
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel "800" )
        , SvgAttr.y ( viewStringMulY mainModel "50" )
        , SvgAttr.fontSize ( viewStringMulY mainModel "20" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text ( "Ping: " ++ String.fromInt model.delayTime ++ "ms" ) ]
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel "50" )
        , SvgAttr.y ( viewStringMulY mainModel "50" )
        , SvgAttr.fontSize ( viewStringMulY mainModel "40" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text ("Room " ++ model.gameRoom.name) ]
    , Svg.line
        [ SvgAttr.x1 ( viewStringMulX mainModel "50" )
        , SvgAttr.y1 ( viewStringMulY mainModel "100" )
        , SvgAttr.x2 ( viewStringMulX mainModel "1000" )
        , SvgAttr.y2 ( viewStringMulY mainModel "100" )
        , SvgAttr.stroke "#000000"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 ( viewStringMulX mainModel "800" )
        , SvgAttr.y1 ( viewStringMulY mainModel "100" )
        , SvgAttr.x2 ( viewStringMulX mainModel "800" )
        , SvgAttr.y2 ( viewStringMulY mainModel "850" )
        , SvgAttr.stroke "#000000"
        ]
        []
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel "50" )
        , SvgAttr.y ( viewStringMulY mainModel "175" )
        , SvgAttr.fontSize ( viewStringMulY mainModel "50" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ case model.gameRoom.gameStatus of
            Battle ->
                Svg.text ("Players (" ++ String.fromInt (Array.length model.gameRoom.clientList) ++ "/2)")
        ]
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel "850" )
        , SvgAttr.y ( viewStringMulY mainModel "180" )
        , SvgAttr.fontSize ( viewStringMulY mainModel "50" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "Game Info" ]
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel "900" )
        , SvgAttr.y ( viewStringMulY mainModel "250" )
        , SvgAttr.fontSize ( viewStringMulY mainModel "30" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ case model.gameRoom.gameStatus of
            Battle ->
                Svg.text "Type: Battle"
        ]
    , Svg.text_
        [ SvgAttr.x ( viewStringMulX mainModel "900" )
        , SvgAttr.y ( viewStringMulY mainModel "320" )
        , SvgAttr.fontSize ( viewStringMulY mainModel "30" )
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ case model.gameRoom.gameStatus of
            Battle ->
                Svg.text "Max people: 2"
        ]
    ]


drawRoomButton : MainModel.Model -> Model -> List (Svg Msg)
drawRoomButton mainModel model =
    List.append
--quitRoomButton
        [ Svg.rect
            [ SvgAttr.x ( viewStringMulX mainModel "20" )
            , SvgAttr.y ( viewStringMulY mainModel "750" )
            , SvgAttr.width ( viewStringMulY mainModel "200" )
            , SvgAttr.height ( viewStringMulY mainModel "80" )
            , SvgAttr.fill (withDefault "Black" (Array.get quitRoomButtonId model.buttonState))
            ]
            []
        , Svg.text_
            [ SvgAttr.x ( viewStringMulX mainModel "50" )
            , SvgAttr.y ( viewStringMulY mainModel "795" )
            , SvgAttr.fontSize ( viewStringMulY mainModel "30" )
            , SvgAttr.textAnchor "left"
            , SvgAttr.fill "#000000"
            ]
            [ Svg.text "quit room" ]
        , Svg.rect
            [ SvgAttr.x ( viewStringMulX mainModel "20" )
            , SvgAttr.y ( viewStringMulY mainModel "750" )
            , SvgAttr.width ( viewStringMulY mainModel "200" )
            , SvgAttr.height ( viewStringMulY mainModel "80" )
            , SvgAttr.fill "#00000000"
            , SvgEvent.onMouseOver (OnMouseOver quitRoomButtonId)
            , SvgEvent.onMouseOut (OnMouseOut quitRoomButtonId)
            , SvgEvent.onMouseDown (OnMouseDown quitRoomButtonId)
            , SvgEvent.onMouseUp (OnMouseUp quitRoomButtonId)
            ]
            []
        ]
--confirmRoomNameButton
        (if (withDefault defaultClient (Array.get 0 model.gameRoom.clientList)).uuid == model.client.uuid then
            [ Svg.foreignObject
                [ SvgAttr.x ( viewStringMulX mainModel "1000" )
                , SvgAttr.y ( viewStringMulY mainModel "30" )
                , SvgAttr.width ( viewStringMulY mainModel "180" )
                , SvgAttr.height ( viewStringMulY mainModel "50" )
                , SvgAttr.fill "#00FF00"
                ]
                [ input
                    [ HtmlAttr.size 10
                    , HtmlAttr.type_ "text"
                    --, HtmlAttr.value "roomName"
                    , HtmlAttr.maxlength 10
                    , HtmlEvents.onInput (OnInput ownRoomNameTextBoxId)
                    ]
                    []
                ]
            , Svg.text_
                [ SvgAttr.x ( viewStringMulX mainModel "1000" )
                , SvgAttr.y ( viewStringMulY mainModel "20" )
                , SvgAttr.fontSize ( viewStringMulY mainModel "20" )
                , SvgAttr.textAnchor "left"
                , SvgAttr.fill "#000000"
                ]
                [ Svg.text "Input room name" ]
--confirm
            , Svg.rect
                [ SvgAttr.x ( viewStringMulX mainModel "1030" )
                , SvgAttr.y ( viewStringMulY mainModel "80" )
                , SvgAttr.width ( viewStringMulY mainModel "120" )
                , SvgAttr.height ( viewStringMulY mainModel "40" )
                , SvgAttr.fill (withDefault "Black" (Array.get confirmOwnRoomNameButtonId model.buttonState))
                ]
                []
            , Svg.text_
                [ SvgAttr.x ( viewStringMulX mainModel "1050" )
                , SvgAttr.y ( viewStringMulY mainModel "105" )
                , SvgAttr.fontSize ( viewStringMulY mainModel "20" )
                , SvgAttr.textAnchor "left"
                , SvgAttr.fill "#000000"
                ]
                [ Svg.text "confirm" ]
            , Svg.rect
                [ SvgAttr.x ( viewStringMulX mainModel "1030" )
                , SvgAttr.y ( viewStringMulY mainModel "80" )
                , SvgAttr.width ( viewStringMulY mainModel "120" )
                , SvgAttr.height ( viewStringMulY mainModel "40" )
                , SvgAttr.fill "#00000000"
                , SvgEvent.onMouseOver (OnMouseOver confirmOwnRoomNameButtonId)
                , SvgEvent.onMouseOut (OnMouseOut confirmOwnRoomNameButtonId)
                , SvgEvent.onMouseDown (OnMouseDown confirmOwnRoomNameButtonId)
                , SvgEvent.onMouseUp (OnMouseUp confirmOwnRoomNameButtonId)
                ]
                []
--startGameButton
            , Svg.rect
                [ SvgAttr.x ( viewStringMulX mainModel "500" )
                , SvgAttr.y ( viewStringMulY mainModel "750" )
                , SvgAttr.width ( viewStringMulY mainModel "200" )
                , SvgAttr.height ( viewStringMulY mainModel "80" )
                ,
                case model.gameRoom.gameStatus of
                    Battle ->
                        if Array.length model.gameRoom.clientList == 2 then
                            SvgAttr.fill (withDefault "Black" (Array.get startRoomGameButtonId model.buttonState))

                        else
                            SvgAttr.fill buttonDownColor
                ]
                []
            , Svg.text_
                [ SvgAttr.x ( viewStringMulX mainModel "530" )
                , SvgAttr.y ( viewStringMulY mainModel "795" )
                , SvgAttr.fontSize ( viewStringMulY mainModel "30" )
                , SvgAttr.textAnchor "left"
                , SvgAttr.fill "#000000"
                ]
                [ Svg.text "Start Game" ]
            , Svg.rect
                ( List.append
                    [ SvgAttr.x ( viewStringMulX mainModel "500" )
                    , SvgAttr.y ( viewStringMulY mainModel "750" )
                    , SvgAttr.width ( viewStringMulY mainModel "200" )
                    , SvgAttr.height ( viewStringMulY mainModel "80" )
                    , SvgAttr.fill "#00000000"
                    ]
                    ( case model.gameRoom.gameStatus of
                        Battle ->
                            if Array.length model.gameRoom.clientList == 2 then
                                [ SvgEvent.onMouseOver (OnMouseOver startRoomGameButtonId)
                                , SvgEvent.onMouseOut (OnMouseOut startRoomGameButtonId)
                                , SvgEvent.onMouseDown (OnMouseDown startRoomGameButtonId)
                                , SvgEvent.onMouseUp (OnMouseUp startRoomGameButtonId)
                                ]

                            else
                                []
                    )
                )
                []
            ]
        else
            []
        )

drawRoomClientList : MainModel.Model -> Model -> List (Svg Msg)
drawRoomClientList mainModel model =
    List.map
        (\i ->
            Svg.text_
                [ SvgAttr.x ( viewStringMulX mainModel "30" )
                , SvgAttr.y ( viewStringMulY mainModel (String.fromInt (250 + 75 * i)) )
                , SvgAttr.fontSize ( viewStringMulY mainModel "30" )
                , SvgAttr.textAnchor "left"
                , SvgAttr.fill "#000000"
                ]
                [ if (withDefault defaultClient (Array.get i model.gameRoom.clientList)).uuid == model.client.uuid then
                    Svg.text ((withDefault defaultClient (Array.get i model.gameRoom.clientList)).name ++ "(you)")

                  else
                    Svg.text ((withDefault defaultClient (Array.get i model.gameRoom.clientList)).name)
                ]
        )
        (List.range 0 (Array.length model.gameRoom.clientList - 1))

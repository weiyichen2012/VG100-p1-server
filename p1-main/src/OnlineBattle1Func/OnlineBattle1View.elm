module OnlineBattle1View exposing (..)

import Array
import BasicFunction exposing (defaultBoundaries, viewStringMulX, viewStringMulY, viewToggleButton)
import Html exposing (Html, div)
import Html.Attributes as HtmlAttr
import MainModel
import Maybe exposing (withDefault)
import OnlineBattle1Constant exposing (..)
import OnlineBattle1Init exposing (ballRadius, paddleLength, stageSize)
import OnlineBattle1Type exposing (AliveStatus(..), DelayAction(..), Model)
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import Type exposing (Msg(..))



--drawScene: the whole scene


view : MainModel.Model -> Html Msg
view mainModel =
    let
        model =
            mainModel.onlineBattle1Model
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
            (drawBackground mainModel model
                ++ defaultBoundaries mainModel OnlineBattle1Constant.windowSize
                ++ drawPaddle mainModel model
                ++ drawBall mainModel model
                ++ drawGameStatus mainModel model
                ++ viewToggleButton mainModel
                ++ drawControlButtons mainModel model
            )
        ]



--drawPaddle: draw paddle


drawPaddle : MainModel.Model -> Model -> List (Svg Msg)
drawPaddle mainModel model =
    [ Svg.line
        [ SvgAttr.x1
            (viewStringMulX mainModel
                ((Tuple.first model.scene.paddleUp.pos - paddleLength / 2 * cos ( degrees model.scene.paddleUp.dir))
                    |> String.fromFloat
                )
            )
        , SvgAttr.y1
            (viewStringMulY mainModel
                ((Tuple.second model.scene.paddleUp.pos - paddleLength / 2 * sin ( degrees model.scene.paddleUp.dir))
                    |> String.fromFloat
                )
            )
        , SvgAttr.x2
            (viewStringMulX mainModel
                ((Tuple.first model.scene.paddleUp.pos + paddleLength / 2 * cos ( degrees model.scene.paddleUp.dir))
                    |> String.fromFloat
                )
            )
        , SvgAttr.y2
            (viewStringMulY mainModel
                ((Tuple.second model.scene.paddleUp.pos + paddleLength / 2 * sin ( degrees model.scene.paddleUp.dir))
                    |> String.fromFloat
                )
            )
        , SvgAttr.stroke "#0000FF"
        , SvgAttr.strokeWidth (viewStringMulY mainModel "10")
        ]
        []
    , Svg.line
        [ SvgAttr.x1
            (viewStringMulX mainModel
                ((Tuple.first model.scene.paddleDown.pos - paddleLength / 2 * cos ( degrees model.scene.paddleDown.dir))
                    |> String.fromFloat
                )
            )
        , SvgAttr.y1
            (viewStringMulY mainModel
                ((Tuple.second model.scene.paddleDown.pos - paddleLength / 2 * sin ( degrees model.scene.paddleDown.dir))
                    |> String.fromFloat
                )
            )
        , SvgAttr.x2
            (viewStringMulX mainModel
                ((Tuple.first model.scene.paddleDown.pos + paddleLength / 2 * cos ( degrees model.scene.paddleDown.dir))
                    |> String.fromFloat
                )
            )
        , SvgAttr.y2
            (viewStringMulY mainModel
                ((Tuple.second model.scene.paddleDown.pos + paddleLength / 2 * sin ( degrees model.scene.paddleDown.dir))
                    |> String.fromFloat
                )
            )
        , SvgAttr.stroke "#0000FF"
        , SvgAttr.strokeWidth (viewStringMulY mainModel "10")
        ]
        []
    ]



--drawBall: draw ball


drawBall : MainModel.Model -> Model -> List (Svg Msg)
drawBall mainModel model =
    [ Svg.circle
        [ SvgAttr.cx
            (viewStringMulX mainModel
                (model.scene.ball.pos
                    |> Tuple.first
                    |> String.fromFloat
                )
            )
        , SvgAttr.cy
            (viewStringMulY mainModel
                (model.scene.ball.pos
                    |> Tuple.second
                    |> String.fromFloat
                )
            )
        , SvgAttr.r
            (viewStringMulY mainModel
                (ballRadius
                    |> String.fromFloat
                )
            )
        , SvgAttr.fill "Red"
        ]
        []
    ]



--drawBoundary: draw boundary


drawBackground : MainModel.Model -> Model -> List (Svg Msg)
drawBackground mainModel model =
    [ Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "0")
        , SvgAttr.y (viewStringMulY mainModel "0")
        , SvgAttr.width (viewStringMulY mainModel (String.fromFloat (Tuple.first stageSize)))
        , SvgAttr.height (viewStringMulY mainModel (String.fromFloat (Tuple.second stageSize)))
        , SvgAttr.fill "#E0E0E0"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 (viewStringMulX mainModel "0")
        , SvgAttr.y1 (viewStringMulY mainModel (String.fromFloat (Tuple.second stageSize)))
        , SvgAttr.x2 (viewStringMulX mainModel (String.fromFloat (Tuple.first stageSize)))
        , SvgAttr.y2 (viewStringMulY mainModel (String.fromFloat (Tuple.second stageSize)))
        , SvgAttr.stroke "#FF0000"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 (viewStringMulX mainModel "0")
        , SvgAttr.y1 (viewStringMulY mainModel "3")
        , SvgAttr.x2 (viewStringMulX mainModel (String.fromFloat (Tuple.first stageSize)))
        , SvgAttr.y2 (viewStringMulY mainModel "3")
        , SvgAttr.stroke "#FF0000"
        ]
        []
    , Svg.text_
        [ SvgAttr.x (viewStringMulX mainModel "0")
        , SvgAttr.y (viewStringMulY mainModel "900")
        , SvgAttr.fontSize (viewStringMulY mainModel "20" ++ "px")
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ text "Press AD to move, WS to rotate" ]
    ]


drawGameStatus : MainModel.Model -> Model -> List (Svg Msg)
drawGameStatus mainModel model =
    List.concat
        [ if model.delayTime > 0 then
            [ Svg.text_
                [ SvgAttr.x (viewStringMulX mainModel "150")
                , SvgAttr.y (viewStringMulY mainModel "500")
                , SvgAttr.fontSize (viewStringMulY mainModel "20" ++ "px")
                , SvgAttr.textAnchor "left"
                , SvgAttr.fill "#000000"
                ]
                [ text
                    ((case model.delayAction of
                        Preparing ->
                            "Game starts in "

                        SwitchToRoom ->
                            "Go back to room in "

                        OnePlayerDisconnect ->
                            "One player disconnects, go back to room in"
                     )
                        ++ String.fromInt (Basics.round model.delayTime)
                        ++ "ms"
                    )
                ]
            ]

          else
            []
        , [ Svg.text_
                [ SvgAttr.x (viewStringMulX mainModel "500")
                , SvgAttr.y (viewStringMulY mainModel "50")
                , SvgAttr.fontSize (viewStringMulY mainModel "50" ++ "px")
                , SvgAttr.textAnchor "left"
                , SvgAttr.fill "#000000"
                ]
                [ text
                    ("Score: "
                        ++ String.fromInt model.upScore
                        ++ (if model.upScore == winScore then
                                ", wins!"

                            else
                                ""
                           )
                    )
                ]
          ]
        , [ Svg.text_
                [ SvgAttr.x (viewStringMulX mainModel "500")
                , SvgAttr.y (viewStringMulY mainModel "850")
                , SvgAttr.fontSize (viewStringMulY mainModel "50" ++ "px")
                , SvgAttr.textAnchor "left"
                , SvgAttr.fill "#000000"
                ]
                [ text
                    ("Score: "
                        ++ String.fromInt model.downScore
                        ++ (if model.downScore == winScore then
                                ", wins!"

                            else
                                ""
                           )
                    )
                ]
          ]
        , [ Svg.text_
                [ SvgAttr.x (viewStringMulX mainModel "530")
                , SvgAttr.y (viewStringMulY mainModel "150")
                , SvgAttr.fontSize (viewStringMulY mainModel "20")
                , SvgAttr.textAnchor "left"
                , SvgAttr.fill "#000000"
                ]
                [ text ("Ping: " ++ String.fromInt model.pingTime ++ "ms") ]
          ]
        ]


drawControlButtons : MainModel.Model -> Model -> List (Svg Msg)
drawControlButtons mainModel model =
-- up
    [ Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "150")
        , SvgAttr.y (viewStringMulY mainModel "1100")
        , SvgAttr.width (viewStringMulY mainModel "200")
        , SvgAttr.height (viewStringMulY mainModel "200")
        , SvgAttr.fill (withDefault "Black" (Array.get buttonUpID model.buttonState))
        ]
        []
    --, Svg.text_
    --    [ SvgAttr.x (viewStringMulX mainModel "225")
    --    , SvgAttr.y (viewStringMulY mainModel "1240")
    --    , SvgAttr.fontSize (viewStringMulY mainModel "100")
    --    , SvgAttr.textAnchor "left"
    --    , SvgAttr.fill "#000000"
    --    ]
    --    [ Svg.text "↑" ]
    , Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "150")
        , SvgAttr.y (viewStringMulY mainModel "1100")
        , SvgAttr.width (viewStringMulY mainModel "200")
        , SvgAttr.height (viewStringMulY mainModel "200")
        , SvgAttr.fill "#00000000"
        , SvgEvent.onMouseOver (OnMouseOver ( buttonUpID + buttonIDFrom ) )
        , SvgEvent.onMouseOut (OnMouseOut ( buttonUpID + buttonIDFrom ) )
        , SvgEvent.onMouseDown (OnMouseDown ( buttonUpID + buttonIDFrom ) )
        , SvgEvent.onMouseUp (OnMouseUp ( buttonUpID + buttonIDFrom ) )
        ]
        []
-- down
    , Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "150")
        , SvgAttr.y (viewStringMulY mainModel "1350")
        , SvgAttr.width (viewStringMulY mainModel "200")
        , SvgAttr.height (viewStringMulY mainModel "200")
        , SvgAttr.fill (withDefault "Black" (Array.get buttonDownID model.buttonState))
        ]
        []
    --, Svg.text_
    --    [ SvgAttr.x (viewStringMulX mainModel "225")
    --    , SvgAttr.y (viewStringMulY mainModel "1490")
    --    , SvgAttr.fontSize (viewStringMulY mainModel "100")
    --    , SvgAttr.textAnchor "left"
    --    , SvgAttr.fill "#000000"
    --    ]
    --    [ Svg.text "↓" ]
    , Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "150")
        , SvgAttr.y (viewStringMulY mainModel "1350")
        , SvgAttr.width (viewStringMulY mainModel "200")
        , SvgAttr.height (viewStringMulY mainModel "200")
        , SvgAttr.fill "#00000000"
        , SvgEvent.onMouseOver (OnMouseOver ( buttonDownID + buttonIDFrom ) )
        , SvgEvent.onMouseOut (OnMouseOut ( buttonDownID + buttonIDFrom ) )
        , SvgEvent.onMouseDown (OnMouseDown ( buttonDownID + buttonIDFrom ) )
        , SvgEvent.onMouseUp (OnMouseUp ( buttonDownID + buttonIDFrom ) )
        ]
        []
--left
    , Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "-100")
        , SvgAttr.y (viewStringMulY mainModel "1350")
        , SvgAttr.width (viewStringMulY mainModel "200")
        , SvgAttr.height (viewStringMulY mainModel "200")
        , SvgAttr.fill (withDefault "Black" (Array.get buttonLeftID model.buttonState))
        ]
        []
    --, Svg.text_
    --    [ SvgAttr.x (viewStringMulX mainModel "-50")
    --    , SvgAttr.y (viewStringMulY mainModel "1490")
    --    , SvgAttr.fontSize (viewStringMulY mainModel "100")
    --    , SvgAttr.textAnchor "left"
    --    , SvgAttr.fill "#000000"
    --    ]
    --    [ Svg.text "←" ]
    , Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "-100")
        , SvgAttr.y (viewStringMulY mainModel "1350")
        , SvgAttr.width (viewStringMulY mainModel "200")
        , SvgAttr.height (viewStringMulY mainModel "200")
        , SvgAttr.fill "#00000000"
        , SvgEvent.onMouseOver (OnMouseOver ( buttonLeftID + buttonIDFrom ) )
        , SvgEvent.onMouseOut (OnMouseOut ( buttonLeftID + buttonIDFrom ) )
        , SvgEvent.onMouseDown (OnMouseDown ( buttonLeftID + buttonIDFrom ) )
        , SvgEvent.onMouseUp (OnMouseUp ( buttonLeftID + buttonIDFrom ) )
        ]
        []
--right
    , Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "400")
        , SvgAttr.y (viewStringMulY mainModel "1350")
        , SvgAttr.width (viewStringMulY mainModel "200")
        , SvgAttr.height (viewStringMulY mainModel "200")
        , SvgAttr.fill (withDefault "Black" (Array.get buttonRightID model.buttonState))
        ]
        []
    --, Svg.text_
    --    [ SvgAttr.x (viewStringMulX mainModel "450")
    --    , SvgAttr.y (viewStringMulY mainModel "1490")
    --    , SvgAttr.fontSize (viewStringMulY mainModel "100")
    --    , SvgAttr.textAnchor "left"
    --    , SvgAttr.fill "#000000"
    --    ]
    --    [ Svg.text "→" ]
    , Svg.rect
        [ SvgAttr.x (viewStringMulX mainModel "400")
        , SvgAttr.y (viewStringMulY mainModel "1350")
        , SvgAttr.width (viewStringMulY mainModel "200")
        , SvgAttr.height (viewStringMulY mainModel "200")
        , SvgAttr.fill "#00000000"
        , SvgEvent.onMouseOver (OnMouseOver ( buttonRightID + buttonIDFrom ) )
        , SvgEvent.onMouseOut (OnMouseOut ( buttonRightID + buttonIDFrom ) )
        , SvgEvent.onMouseDown (OnMouseDown ( buttonRightID + buttonIDFrom ) )
        , SvgEvent.onMouseUp (OnMouseUp ( buttonRightID + buttonIDFrom ) )
        ]
        []
    ]

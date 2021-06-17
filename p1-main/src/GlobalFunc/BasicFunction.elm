port module BasicFunction exposing (..)
import Array exposing (Array)
import Constant exposing (toggleBiggerButtonID, toggleSmallerButtonID)
import MainModel
import Maybe exposing (withDefault)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import Type exposing (LineSegment, Msg(..), Pos)



--listRange2D: generate 2 dimension List on x, y


listRange2D : ( Int, Int ) -> List ( Int, Int )
listRange2D ( x, y ) =
    let
        rangeX =
            List.range 0 (x - 1)

        rangeY =
            List.range 0 (y - 1)

        l =
            \i -> List.map (\j -> ( j, i )) rangeX
    in
    List.map l rangeY
        |> List.concat



--listRange2D: generate 2 dimension Array on x, y


arrayRange2D : ( Int, Int ) -> Array ( Int, Int )
arrayRange2D ( x, y ) =
    let
        rangeX =
            List.range 0 (x - 1)

        rangeY =
            List.range 0 (y - 1)

        l =
            \i -> List.map (\j -> ( j, i )) rangeX
    in
    List.map l rangeY
        |> List.concat
        |> Array.fromList



--plusPos: add two Pos


plusPos : Pos -> Pos -> Pos
plusPos a b =
    let
        a_x =
            Tuple.first a

        a_y =
            Tuple.second a

        b_x =
            Tuple.first b

        b_y =
            Tuple.second b
    in
    ( a_x + b_x, a_y + b_y )



--plusLineSegment: add two LineSegment


plusLineSegment : LineSegment -> LineSegment -> LineSegment
plusLineSegment a b =
    let
        a_p0 =
            Tuple.first a

        a_p1 =
            Tuple.second a

        b_p0 =
            Tuple.first b

        b_p1 =
            Tuple.second b
    in
    ( plusPos a_p0 b_p0, plusPos a_p1 b_p1 )



--intListDelete


intListDelete : Int -> List Int -> List Int
intListDelete a l =
    List.filter (\x -> x /= a) l


defaultBoundaries : MainModel.Model -> ( Float, Float ) -> List (Svg Msg)
defaultBoundaries mainModel windowSize =
    [ Svg.line
        [ SvgAttr.x1 ( viewStringMulX mainModel "0" )
        , SvgAttr.y1 ( viewStringMulY mainModel "0" )
        , SvgAttr.x2 ( viewStringMulX mainModel (String.fromFloat (Tuple.first windowSize)) )
        , SvgAttr.y2 ( viewStringMulY mainModel "0" )
        , SvgAttr.stroke "#000000"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 ( viewStringMulX mainModel (String.fromFloat (Tuple.first windowSize)) )
        , SvgAttr.y1 ( viewStringMulY mainModel "0" )
        , SvgAttr.x2 ( viewStringMulX mainModel (String.fromFloat (Tuple.first windowSize)) )
        , SvgAttr.y2 ( viewStringMulY mainModel (String.fromFloat (Tuple.second windowSize)) )
        , SvgAttr.stroke "#000000"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 ( viewStringMulX mainModel (String.fromFloat (Tuple.first windowSize)) )
        , SvgAttr.y1 ( viewStringMulY mainModel (String.fromFloat (Tuple.second windowSize)) )
        , SvgAttr.x2 ( viewStringMulX mainModel "0" )
        , SvgAttr.y2 ( viewStringMulY mainModel (String.fromFloat (Tuple.second windowSize)) )
        , SvgAttr.stroke "#000000"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 ( viewStringMulX mainModel "0" )
        , SvgAttr.y1 ( viewStringMulY mainModel (String.fromFloat (Tuple.second windowSize)) )
        , SvgAttr.x2 ( viewStringMulX mainModel "0" )
        , SvgAttr.y2 ( viewStringMulY mainModel "0" )
        , SvgAttr.stroke "#000000"
        ]
        []
    ]

viewStringMulY : MainModel.Model -> String -> String
viewStringMulY mainModel s =
    let
        sn = withDefault 0.0 (String.toFloat s)
    in
    String.fromFloat ( sn * mainModel.display.times )

viewStringMulX : MainModel.Model -> String -> String
viewStringMulX mainModel s =
    let
        sn = withDefault 0.0 (String.toFloat s)
    in
    String.fromFloat ( 50.0 + ( sn * mainModel.display.times ) )

viewToggleButton : MainModel.Model -> List ( Svg Msg )
viewToggleButton mainModel =
    --bigger
    [ Svg.rect
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "40"
        , SvgAttr.height "40"
        , SvgAttr.fill (withDefault "Black" (Array.get 0 mainModel.buttonState))
        ]
        []
    , Svg.text_
        [ SvgAttr.x "8"
        , SvgAttr.y "27"
        , SvgAttr.fontSize "30"
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "+" ]
    , Svg.rect
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "40"
        , SvgAttr.height "40"
        , SvgAttr.fill "#00000000"
        , SvgEvent.onMouseOver (OnMouseOver toggleBiggerButtonID)
        , SvgEvent.onMouseOut (OnMouseOut toggleBiggerButtonID)
        , SvgEvent.onMouseDown (OnMouseDown toggleBiggerButtonID)
        , SvgEvent.onMouseUp (OnMouseUp toggleBiggerButtonID)
        ]
        []
    --smaller
    , Svg.rect
        [ SvgAttr.x "0"
        , SvgAttr.y "50"
        , SvgAttr.width "40"
        , SvgAttr.height "40"
        , SvgAttr.fill (withDefault "Black" (Array.get 1 mainModel.buttonState))
        ]
        []
    , Svg.text_
        [ SvgAttr.x "13"
        , SvgAttr.y "77"
        , SvgAttr.fontSize "30"
        , SvgAttr.textAnchor "left"
        , SvgAttr.fill "#000000"
        ]
        [ Svg.text "-" ]
    , Svg.rect
        [ SvgAttr.x "0"
        , SvgAttr.y "50"
        , SvgAttr.width "40"
        , SvgAttr.height "40"
        , SvgAttr.fill "#00000000"
        , SvgEvent.onMouseOver (OnMouseOver toggleSmallerButtonID)
        , SvgEvent.onMouseOut (OnMouseOut toggleSmallerButtonID)
        , SvgEvent.onMouseDown (OnMouseDown toggleSmallerButtonID)
        , SvgEvent.onMouseUp (OnMouseUp toggleSmallerButtonID)
        ]
        []
    ]


--


port consoleLog : String -> Cmd msg
port serverMsg : ( String -> msg ) -> Sub msg
port clientSend : String -> Cmd msg

module Constant exposing (..)

--defaultLineSegment: uses with withDefault

import Type exposing (LineSegment, DisplayIndex)


buttonNormalColor =
    "#E0E0E0"


buttonOverColor =
    "#B0B0B0"


buttonDownColor =
    "#808080"

defaultLineSegment : LineSegment
defaultLineSegment =
    ( ( 0, 0 ), ( 0, 1 ) )


windowSize : ( Float, Float )
windowSize =
    ( 1200.0, 900.0 )

toggleBiggerButtonID =
    40

toggleSmallerButtonID =
    41
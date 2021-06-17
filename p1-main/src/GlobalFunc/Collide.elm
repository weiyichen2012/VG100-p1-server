module Collide exposing (..)

import Type exposing (CollisionBox(..), IfCollide(..), LineSegment, Msg, Pos)



--distancePointToPoint: distance between two points (p, q)


distancePointToPoint : Pos -> Pos -> Float
distancePointToPoint p q =
    let
        deltaX =
            Tuple.first p - Tuple.first q

        deltaY =
            Tuple.second p - Tuple.second q
    in
    sqrt (deltaX ^ 2 + deltaY ^ 2)



--distancePointToLineSegment: distance from p to the nearest dot on line segment (not line!!!)


distancePointToLineSegment : Pos -> LineSegment -> Float
distancePointToLineSegment p lineSegment =
    let
        p_x =
            Tuple.first p

        p_y =
            Tuple.second p

        l1 =
            Tuple.first lineSegment

        l2 =
            Tuple.second lineSegment

        l1_x =
            Tuple.first l1

        l1_y =
            Tuple.second l1

        l2_x =
            Tuple.first l2

        l2_y =
            Tuple.second l2

        dis_p_l1 =
            distancePointToPoint p l1

        dis_p_l2 =
            distancePointToPoint p l2

        l_a =
            if l1_x == l2_x then
                -1

            else
                (l1_y - l2_y) / (l1_x - l2_x)

        l_b =
            if l1_x == l2_x then
                0

            else
                -1

        l_c =
            if l1_x == l2_x then
                l1_x

            else if l1_y == l2_y then
                l1_y

            else
                -l_a * l2_x - l_b * l2_y

        dis_p_l =
            abs (l_a * p_x + l_b * p_y + l_c) / sqrt (l_a ^ 2 + l_b ^ 2)

        perpendicular_x =
            (l_b * l_b * p_x - l_a * l_b * p_y - l_a * l_c) / (l_a ^ 2 + l_b ^ 2)
    in
    if l1_x == l2_x then
        if min l1_y l2_y <= p_y && p_y <= max l1_y l2_y then
            dis_p_l

        else
            min dis_p_l1 dis_p_l2

    else if min l1_x l2_x <= perpendicular_x && perpendicular_x <= max l1_x l2_x then
        dis_p_l

    else
        min dis_p_l1 dis_p_l2



--collideLineSegmentNewDir: new dir once point collide on line segment


collideLineSegmentNewDir : Float -> LineSegment -> Float
collideLineSegmentNewDir dir lineSegment =
    let
        l1 =
            Tuple.first lineSegment

        l2 =
            Tuple.second lineSegment

        l1_x =
            Tuple.first l1

        l1_y =
            Tuple.second l1

        l2_x =
            Tuple.first l2

        l2_y =
            Tuple.second l2

        lineSegmentDir =
            if l1_x == l2_x then
                pi / 2

            else if l1_y == l2_y then
                0

            else
                atan ((l1_y - l2_y) / (l1_x - l2_x))
    in
    -(dir - lineSegmentDir) + lineSegmentDir



--lineSegmentDir
--getLineSegmentDir: get the line segment's direction


getLineSegmentDir : LineSegment -> Float
getLineSegmentDir lineSegment =
    let
        l1 =
            Tuple.first lineSegment

        l2 =
            Tuple.second lineSegment

        l1_x =
            Tuple.first l1

        l1_y =
            Tuple.second l1

        l2_x =
            Tuple.first l2

        l2_y =
            Tuple.second l2

        lineSegmentDir =
            if l1_x == l2_x then
                pi / 2

            else if l1_y == l2_y then
                0

            else
                atan ((l1_y - l2_y) / (l1_x - l2_x))
    in
    lineSegmentDir

module OnlineBattle1Collide exposing (updateCollide)

import BasicFunction exposing (clientSend)
import Collide exposing (collideLineSegmentNewDir, distancePointToLineSegment)
import OnlineBattle1Constant exposing (winScore)
import OnlineBattle1Init exposing (ballRadius, paddleCollideInterval, paddleLength, stageSize)
import OnlineBattle1Type exposing (AliveStatus(..), Ball, DelayAction(..), Model, Paddle, Scene)
import Type exposing (CollisionBox(..), IfCollide(..), LineSegment, Msg)



--update Collision that may happen


updateCollide : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateCollide ( model, cmd ) =
    let
        ( collideBoundaryModel, collideBoundaryCmd ) =
            ( { model | collideStatus = NoCollide }, cmd )
                |> collideBoundary

        ( collideModel, collideCmd ) =
            if model.collideStatus == Collide then
                ( collideBoundaryModel, collideBoundaryCmd )

            else
                collidePaddle ( { collideBoundaryModel | collideFrameNum = 0}, collideBoundaryCmd )

        ( newModel, newCmd ) =
            ( collideModel, collideCmd )
            --judgeStuck ( collideModel, collideCmd )
    in
        ( newModel, newCmd )



--collideLineSegment: check if ball bump into line segment


collideLineSegment : LineSegment -> Model -> Model
collideLineSegment lineSegment model =
    if distancePointToLineSegment model.scene.ball.pos lineSegment < ballRadius then
        if model.collideStatus == NoCollide then
            let
                newBall =
                    Ball (collideLineSegmentNewDir model.scene.ball.dir lineSegment) model.scene.ball.pos model.scene.ball.collisionBox

                oldScene =
                    model.scene

                newScene =
                    { oldScene | ball = newBall }
            in
            { model | scene = newScene, collideStatus = Collide, collideFrameNum = model.collideFrameNum + 1 }

        else
            { model | collideStatus = Collide }

    else
        model



--collideBoundary: check if ball bump into boundary


collideBoundary : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
collideBoundary ( model, cmd ) =
    let
        x =
            Tuple.first stageSize

        y =
            Tuple.second stageSize

        p0 =
            ( 0, 1 )

        p1 =
            ( x, 0 )

        p2 =
            ( x, y )

        p3 =
            ( 0, y )

        upBound =
            ( p0, p1 )

        rightBound =
            ( p1, p2 )

        downBound =
            ( p2, p3 )

        leftBound =
            ( p3, p0 )
    in
    let
        otherBoundModel =
            model
                |> collideLineSegment rightBound
                |> collideLineSegment leftBound

        downBoundModel =
            { otherBoundModel | collideStatus = NoCollide }
                |> collideLineSegment downBound

        upBoundModel =
            { otherBoundModel | collideStatus = NoCollide }
                |> collideLineSegment upBound

        totalBoundModel =
            model
                |> collideLineSegment rightBound
                |> collideLineSegment leftBound
                |> collideLineSegment upBound
                |> collideLineSegment downBound
    in
    if downBoundModel.collideStatus == Collide || upBoundModel.collideStatus == Collide then
        if downBoundModel.collideStatus == Collide then
            let
                newModel =
                    { totalBoundModel |  collideStatus = Collide, upScore = totalBoundModel.upScore + 1 }
            in
            if newModel.upScore == winScore then
                ( newModel, Cmd.batch [cmd, clientSend "gameClose switchToRoom"] )

            else
                ( newModel, Cmd.batch [ cmd ] )

        else
            let
                newModel =
                    { totalBoundModel |  collideStatus = Collide, downScore = totalBoundModel.downScore + 1 }
            in
            if newModel.downScore == winScore then
                ( newModel, Cmd.batch [cmd, clientSend "gameClose switchToRoom"] )

            else
                ( newModel, cmd )

    else
        if totalBoundModel.collideStatus == Collide then
            ( { totalBoundModel | collideStatus = Collide } , cmd )

        else
            (totalBoundModel, cmd)



--collidePaddle: check if bump into paddle


collidePaddle : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
collidePaddle ( model, cmd ) =
    --if model.frameNum > model.scene.paddleUp.collisionFrameNum && model.frameNum > model.scene.paddleDown.collisionFrameNum then
        let
            paddleUpLineSegment =
                ( ( Tuple.first model.scene.paddleUp.pos - paddleLength / 2 * cos ( degrees model.scene.paddleUp.dir)
                  , Tuple.second model.scene.paddleUp.pos - paddleLength / 2 * sin ( degrees model.scene.paddleUp.dir)
                  )
                , ( Tuple.first model.scene.paddleUp.pos + paddleLength / 2 * cos ( degrees model.scene.paddleUp.dir)
                  , Tuple.second model.scene.paddleUp.pos + paddleLength / 2 * sin ( degrees model.scene.paddleUp.dir)
                  )
                )

            collideUpModel =
                collideLineSegment paddleUpLineSegment { model | collideStatus = NoCollide }

            paddleDownLineSegment =
                ( ( Tuple.first model.scene.paddleDown.pos - paddleLength / 2 * cos ( degrees model.scene.paddleDown.dir)
                  , Tuple.second model.scene.paddleDown.pos - paddleLength / 2 * sin ( degrees model.scene.paddleDown.dir)
                  )
                , ( Tuple.first model.scene.paddleDown.pos + paddleLength / 2 * cos ( degrees model.scene.paddleDown.dir)
                  , Tuple.second model.scene.paddleDown.pos + paddleLength / 2 * sin ( degrees model.scene.paddleDown.dir)
                  )
                )

            collideBothModel =
                collideLineSegment paddleDownLineSegment collideUpModel

            newModel =
                if collideBothModel.collideStatus == Collide then
                    let
                        oldScene =
                            collideBothModel.scene

                        oldPaddleUp =
                            oldScene.paddleUp

                        newPaddleUp =
                            --{ oldPaddleUp | collisionFrameNum = collideBothModel.frameNum + paddleCollideInterval }
                            oldPaddleUp

                        newScene =
                            { oldScene | paddleUp = newPaddleUp }
                    in
                    { collideBothModel | scene = newScene }

                else
                    collideBothModel
        in
        ( newModel, cmd )

    --else
    --    ( model, cmd )

--judgeStuck : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
--judgeStuck ( model, cmd ) =
--    if model.collideFrameNum >= 30 then
--        let
--            oldScene =
--                model.scene
--
--            newScene =
--                { oldScene | ball = Ball (degrees -135) ( 420, 500 ) Circle }
--        in
--        ( { model | scene = newScene, collideFrameNum = 0}, cmd )
--
--    else
--        ( model, cmd )
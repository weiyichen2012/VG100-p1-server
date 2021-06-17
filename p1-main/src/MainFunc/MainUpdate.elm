module MainUpdate exposing (update)

import BasicFunction exposing (consoleLog)
import MainModel exposing (Model)
import Constant exposing (..)
import MenuUpdate
import OnlineBattle1Update
import OnlineBattle1Init
import Type exposing (BattleInformation(..), Job(..), MainModelStatus(..), Msg(..), DisplayIndex)
import Array



--update: do individual update for different mainStatus


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, newCmd ) =
            case msg of
                OnMouseOver num ->
                    if num == toggleBiggerButtonID then
                        ( { model | buttonState = Array.set 0 buttonOverColor model.buttonState }
                        , Cmd.batch [ consoleLog ("MouseOver bigger") ]
                        )

                    else if num == toggleSmallerButtonID then
                        ( { model | buttonState = Array.set 1 buttonOverColor model.buttonState }
                        , Cmd.batch [ consoleLog ("MouseOver smaller") ]
                        )

                    else
                        ( model, Cmd.none )

                OnMouseOut num ->
                    if num == toggleBiggerButtonID then
                        ( { model | buttonState = Array.set 0 buttonNormalColor model.buttonState }
                        , Cmd.batch [ consoleLog ("MouseOut bigger") ]
                        )

                    else if num == toggleSmallerButtonID then
                        ( { model | buttonState = Array.set 1 buttonNormalColor model.buttonState }
                        , Cmd.batch [ consoleLog ("MouseOut smaller") ]
                        )

                    else
                        ( model, Cmd.none )

                OnMouseDown num ->
                    if num == toggleBiggerButtonID then
                        ( { model | buttonState = Array.set 0 buttonDownColor model.buttonState }
                        , Cmd.batch [ consoleLog ("MouseDown bigger") ]
                        )

                    else if num == toggleSmallerButtonID then
                        ( { model | buttonState = Array.set 1 buttonDownColor model.buttonState }
                        , Cmd.batch [ consoleLog ("MouseDown bigger") ]
                        )

                    else
                        ( model, Cmd.none )

                OnMouseUp num ->
                    if num == toggleBiggerButtonID then
                        ( { model | buttonState = Array.set 0 buttonNormalColor model.buttonState, display = DisplayIndex ( Basics.min (model.display.times + 0.05) 1.0 ) }
                        , Cmd.batch [ consoleLog ("MouseDown bigger") ]
                        )

                    else if num == toggleSmallerButtonID then
                        ( { model | buttonState = Array.set 1 buttonNormalColor model.buttonState, display = DisplayIndex ( Basics.max (model.display.times - 0.05) 0.2 ) }
                        , Cmd.batch [ consoleLog ("MouseDown smaller") ]
                        )

                    else
                        ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none)
    in
    case newModel.mainStatus of
        Menu ->
            let
                ( newMenuModel, cmd) =
                    MenuUpdate.update msg newModel.menuModel
            in
            case newModel.menuModel.battleInformation of
                SwitchToOnlineBattle1 asType ->
                    case asType of
                        AsHost ->
                            ( { newModel
                                    | menuModel = { newMenuModel | battleInformation = None }
                                    , onlineBattle1Model = OnlineBattle1Init.init "Host"
                                    , mainStatus = OnlineBattle1 }
                            , cmd
                            )

                        AsClient ->
                            ( { newModel
                                    | menuModel = { newMenuModel | battleInformation = None }
                                    , onlineBattle1Model = OnlineBattle1Init.init "Client"
                                    , mainStatus = OnlineBattle1 }
                            , cmd
                            )

                None ->
                    ( { newModel | menuModel = newMenuModel }, cmd)



        OnlineBattle1 ->
            let
                ( newOnlineBattle1Model, cmd) =
                    OnlineBattle1Update.update msg newModel.onlineBattle1Model
            in
            if newOnlineBattle1Model.mainStatus == Menu then
                ( { newModel
                    | onlineBattle1Model = newOnlineBattle1Model
                    , mainStatus = Menu
                  }
                , cmd
                )

            else
            ( { newModel | onlineBattle1Model = newOnlineBattle1Model }, cmd)
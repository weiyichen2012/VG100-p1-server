module Main exposing (main)

import Browser
import MainInit
import MainSubscriptions
import MainUpdate
import MainView


main =
    Browser.element
        { init = MainInit.init
        , update = MainUpdate.update
        , view = MainView.view
        , subscriptions = MainSubscriptions.subscriptions
        }

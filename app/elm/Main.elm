module Main exposing (main)

import Html exposing (div, h1, text)
import Html.Attributes exposing (class)


main =
    div [ class "jumbotron" ]
        [ h1 []
            [ text "Hello Elm 0.17" ]
        ]

module Main exposing (main)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)


main : Html msg
main =
    div [ class "jumbotron" ]
        [ h1 []
            [ text "Hello Elm 0.18" ]
        ]

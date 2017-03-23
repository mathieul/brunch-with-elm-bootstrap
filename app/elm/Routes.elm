module Routes exposing (Sitemap(..), parsePath, navigateTo, toString)

import Navigation exposing (Location)
import Route exposing (..)


type Sitemap
    = HomeR
    | PostsR
    | PostR Int
    | AboutR
    | NotFoundR


homeR : Route Sitemap
homeR =
    HomeR := static ""


postsR : Route Sitemap
postsR =
    PostsR := static "posts"


postR : Route Sitemap
postR =
    PostR := static "posts" </> int


aboutR : Route Sitemap
aboutR =
    AboutR := static "about"


sitemap : Router Sitemap
sitemap =
    router [ homeR, postsR, postR, aboutR ]


match : String -> Sitemap
match =
    Route.match sitemap
        >> Maybe.withDefault NotFoundR


toString : Sitemap -> String
toString r =
    case r of
        HomeR ->
            reverse homeR []

        PostsR ->
            reverse postsR []

        PostR id ->
            reverse postR [ Basics.toString id ]

        AboutR ->
            reverse aboutR []

        NotFoundR ->
            Debug.crash "cannot render NotFound"


parsePath : Location -> Sitemap
parsePath =
    .pathname >> match


navigateTo : Sitemap -> Cmd msg
navigateTo =
    toString >> Navigation.newUrl

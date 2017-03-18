module Main exposing (main)

import Post exposing (Post)
import Html as H exposing (Html, text, div)
import Html.Attributes as A exposing (class)
import Html.Events as E
import Http
import Json.Decode as JD
import Navigation exposing (Location)
import Routes exposing (Sitemap(..))
import Task
import Markdown
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Bootstrap.Alert as Alert


-- Main
-- ----


main : Program Never Model Msg
main =
    Navigation.program parseRoute
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model
-- ------


type alias Model =
    { route : Sitemap
    , navbarState : Navbar.State
    , ready : Bool
    , posts : List Post
    , post : Maybe Post
    , error : Maybe String
    }


type Msg
    = RouteChanged Sitemap
    | RouteTo Sitemap
    | NavbarMsg Navbar.State
    | Fetch (Result Http.Error (List Post))


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        initialModel =
            { route = Routes.parsePath location
            , navbarState = navbarState
            , ready = False
            , posts = []
            , post = Nothing
            , error = Nothing
            }

        ( model, routeCmd ) =
            handleRoute initialModel.route initialModel
    in
        ( model, Cmd.batch [ navbarCmd, routeCmd ] )



-- Subscriptions
-- -------------


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg



-- Update
-- ------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged route ->
            handleRoute route model

        RouteTo route ->
            model ! [ Routes.navigateTo route ]

        NavbarMsg state ->
            { model | navbarState = state } ! []

        Fetch (Err error) ->
            { model | error = Just (toString error) } ! []

        Fetch (Ok posts) ->
            handleRoute model.route
                { model
                    | ready = True
                    , error = Nothing
                    , posts = posts
                }


parseRoute : Location -> Msg
parseRoute =
    Routes.parsePath >> RouteChanged


handleRoute : Sitemap -> Model -> ( Model, Cmd Msg )
handleRoute route ({ ready } as model) =
    let
        newModel =
            { model | route = route }

        fetchPosts =
            Task.attempt Fetch Post.fetchPosts
    in
        case route of
            PostsR ->
                if ready then
                    newModel ! []
                else
                    newModel ! [ fetchPosts ]

            PostR id ->
                if ready then
                    { newModel | post = Post.lookupPost id newModel.posts } ! []
                else
                    newModel ! [ fetchPosts ]

            _ ->
                newModel ! []



-- View
-- ----


view : Model -> Html Msg
view model =
    Grid.container []
        [ navigation model
        , div [ class "mt-3" ] [ content model ]
        ]


navigation : Model -> Html Msg
navigation model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.brand (linkAttrs HomeR) [ text "Example" ]
        |> Navbar.items
            [ Navbar.itemLink (linkAttrs HomeR) [ text "Home" ]
            , Navbar.itemLink (linkAttrs PostsR) [ text "Posts" ]
            , Navbar.itemLink (linkAttrs AboutR) [ text "About" ]
            ]
        |> Navbar.view model.navbarState


content : Model -> Html Msg
content ({ route } as model) =
    case model.route of
        HomeR ->
            home

        PostsR ->
            if model.ready then
                posts model.posts
            else
                loading

        PostR id ->
            case ( model.ready, model.post ) of
                ( False, _ ) ->
                    loading

                ( True, Nothing ) ->
                    notFound

                ( True, Just p ) ->
                    post p

        AboutR ->
            about

        NotFoundR ->
            notFound


notFound : Html Msg
notFound =
    Alert.danger [ text "Page not found" ]


home : Html Msg
home =
    div []
        [ H.h3 [ class "mb-2" ] [ text "Home" ]
        , H.p []
            [ H.a
                (linkAttrs <| PostR 123)
                [ text "Click to fetch post #123 which doesn't exist" ]
            ]
        ]


about : Html Msg
about =
    Alert.info [ text "About page..." ]


loading : Html Msg
loading =
    Alert.warning [ text "Loading ..." ]


post : Post -> Html Msg
post post =
    div []
        [ H.h3 [ class "mb-2" ] [ text post.title ]
        , H.p [] [ Markdown.toHtml [] post.body ]
        ]


posts : List Post -> Html Msg
posts posts =
    let
        postLink post =
            H.li [] [ H.a (linkAttrs <| PostR post.id) [ text post.title ] ]
    in
        div []
            [ H.h3 [ class "mb-2" ] [ text "Posts" ]
            , H.ul [] (List.map postLink posts)
            ]


linkAttrs : Sitemap -> List (H.Attribute Msg)
linkAttrs route =
    let
        onClickRoute =
            E.onWithOptions
                "click"
                { preventDefault = True
                , stopPropagation = True
                }
                (JD.succeed <| RouteTo route)
    in
        [ A.href <| Routes.toString route
        , onClickRoute
        ]

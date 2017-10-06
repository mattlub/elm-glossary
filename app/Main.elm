module Main exposing (..)

import Html exposing (Html, button, div, h1, h3, ul, li, input, label, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Model exposing (TechnicalTerm, Model)
import Data exposing (initialModel)


-- VIEW


createSearchResult : TechnicalTerm -> Html Msg
createSearchResult term =
    li [ onClick (ClickTerm term) ] [ text term.text ]


containsString : String -> TechnicalTerm -> Bool
containsString string term =
    String.contains string term.text


wordDisplaySection : Maybe TechnicalTerm -> Html Msg
wordDisplaySection term =
    case term of
        Nothing ->
            div []
                [ text "select a word" ]

        Just term ->
            div []
                [ text term.text
                , text term.english
                , text term.arabic
                ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Glossary" ]
        , h3 [] [ text "Search Words" ]
        , input [ onInput ChangeSearchInput, value model.searchInput ] []
        , ul []
            (List.filter (containsString model.searchInput) model.terms
                |> List.map createSearchResult
            )
        , (wordDisplaySection model.displayedWord)
        ]



-- UPDATE


type Msg
    = ChangeSearchInput String
    | ClickTerm TechnicalTerm


addCmdNone : Model -> ( Model, Cmd Msg )
addCmdNone model =
    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSearchInput newInput ->
            { model | searchInput = newInput }
                |> addCmdNone

        ClickTerm term ->
            { model | displayedWord = (Just term) }
                |> addCmdNone



-- INIT


model : Model
model =
    initialModel


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- MAIN


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

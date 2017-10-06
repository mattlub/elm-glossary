module Main exposing (..)

import Html exposing (Html, div, h1, h2, h3, h4, ul, li, input, text, span)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Model exposing (TechnicalTerm, Model)
import Data exposing (initialModel)


-- VIEW
-- creates span with red class if text equals searchInput


createSpan : String -> String -> Html Msg
createSpan searchInput str =
    if String.contains searchInput str then
        span [ class "red" ] [ text str ]
    else
        span [] [ text str ]



-- creates search results li element


createSearchResult : Maybe TechnicalTerm -> String -> TechnicalTerm -> Html Msg
createSearchResult displayedTerm searchInput term =
    let
        liContents =
            if String.length searchInput == 0 then
                [ text term.text ]
            else
                (String.split
                    searchInput
                    term.text
                    |> List.intersperse searchInput
                    |> List.map (createSpan searchInput)
                )

        liClass =
            case displayedTerm of
                Nothing ->
                    "results-li"

                Just value ->
                    if value.text == term.text then
                        "results-li displayed"
                    else
                        "results-li"
    in
        li
            [ class liClass
            , onClick (ClickTerm term)
            ]
            liContents


containsString : String -> TechnicalTerm -> Bool
containsString string term =
    String.contains string term.text


wordDisplaySection : Maybe TechnicalTerm -> Html Msg
wordDisplaySection term =
    case term of
        Nothing ->
            div [ class "word-section" ]
                [ text "select a word to see the definition!" ]

        Just term ->
            div [ class "word-section" ]
                [ h2 []
                    [ text term.text ]
                , div [ class "translation" ]
                    [ h4 [] [ text "English" ]
                    , div [ class "english" ]
                        [ text term.english ]
                    ]
                , div [ class "translation" ]
                    [ h4 [] [ text "Arabic" ]
                    , div [ class "arabic" ]
                        [ text term.arabic ]
                    ]
                ]


startsWithComesFirst : String -> TechnicalTerm -> TechnicalTerm -> Order
startsWithComesFirst searchString a b =
    let
        aStartsWith =
            String.startsWith searchString a.text

        bStartsWith =
            String.startsWith searchString b.text
    in
        case ( aStartsWith, bStartsWith ) of
            ( True, True ) ->
                EQ

            ( True, False ) ->
                LT

            ( False, True ) ->
                GT

            ( False, False ) ->
                EQ


searchSection : Model -> Html Msg
searchSection model =
    div [ class "search-section" ]
        [ input
            [ class "search-input"
            , onInput ChangeSearchInput
            , value model.searchInput
            , placeholder "Search!"
            ]
            []
        , ul [ class "results-list" ]
            (List.filter (containsString model.searchInput) model.terms
                |> List.sortWith (startsWithComesFirst model.searchInput)
                |> List.map (createSearchResult model.displayedTerm model.searchInput)
            )
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Founders and Coders Glossary" ]
        , div [ class "content" ]
            [ searchSection model
            , wordDisplaySection model.displayedTerm
            ]
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
            { model | displayedTerm = (Just term) }
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

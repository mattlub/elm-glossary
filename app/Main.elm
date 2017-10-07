module Main exposing (..)

import Html exposing (Html, div, h1, h2, h3, h4, ul, li, input, text, span)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Regex
import Model exposing (TechnicalTerm, Model)
import Data exposing (initialModel)
import Keyboard


-- VIEW
-- creates span with red class if text equals searchInput


createSpan : String -> String -> Html Msg
createSpan searchInput str =
    if String.contains searchInput str then
        span [ class "red" ] [ text str ]
    else
        span [] [ text str ]


join : String -> String -> String -> String
join joiner a b =
    a ++ joiner ++ b



-- creates search results li element


createSearchResult : Maybe TechnicalTerm -> Int -> String -> Int -> TechnicalTerm -> Html Msg
createSearchResult displayedTerm selectedTermIndex searchInput indexInResults term =
    let
        liContents : List (Html Msg)
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

        liClassDisplayed : Maybe String
        liClassDisplayed =
            case displayedTerm of
                Nothing ->
                    Nothing

                Just value ->
                    if value.text == term.text then
                        Just "displayed"
                    else
                        Nothing

        liClassSelected : Maybe String
        liClassSelected =
            if selectedTermIndex == indexInResults then
                Just "selected"
            else
                Nothing

        liClass : String
        liClass =
            [ Just "results-li", liClassDisplayed, liClassSelected ]
                |> List.filterMap identity
                |> List.foldr (join " ") ""
    in
        li
            [ class liClass
            , onClick (ClickTerm term)
            ]
            liContents


containsString : String -> TechnicalTerm -> Bool
containsString string term =
    Regex.contains (Regex.regex string |> Regex.caseInsensitive) term.text


wordDisplaySection : Maybe TechnicalTerm -> Html Msg
wordDisplaySection term =
    case term of
        Nothing ->
            div [ class "word-section" ]
                [ h3 []
                    [ text "search or select a term to see its definition in English and Arabic." ]
                ]

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


getSearchResults : String -> List TechnicalTerm -> List TechnicalTerm
getSearchResults search allTerms =
    List.filter (containsString search) allTerms
        |> List.sortWith (startsWithComesFirst search)


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
            (getSearchResults model.searchInput model.terms
                |> List.indexedMap (createSearchResult model.displayedTerm model.selectedTermIndex model.searchInput)
            )
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "F&C glossary" ]
        , div [ class "content" ]
            [ searchSection model
            , wordDisplaySection model.displayedTerm
            ]
        ]



-- UPDATE


type Msg
    = ChangeSearchInput String
    | ClickTerm TechnicalTerm
    | KeyMsg Keyboard.KeyCode


getAtIndex : Int -> List TechnicalTerm -> Maybe TechnicalTerm
getAtIndex i terms =
    List.drop i terms
        |> List.head


addCmdNone : Model -> ( Model, Cmd Msg )
addCmdNone model =
    ( model, Cmd.none )


getNewDisplayedTerm : Maybe TechnicalTerm -> TechnicalTerm -> Maybe TechnicalTerm
getNewDisplayedTerm displayedTerm clickedTerm =
    case displayedTerm of
        Nothing ->
            Just clickedTerm

        Just displayedTerm ->
            if displayedTerm == clickedTerm then
                Nothing
            else
                (Just clickedTerm)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSearchInput newInput ->
            { model | searchInput = newInput }
                |> addCmdNone

        ClickTerm clickedTerm ->
            let
                newDisplayedTerm =
                    getNewDisplayedTerm model.displayedTerm clickedTerm
            in
                { model | displayedTerm = newDisplayedTerm }
                    |> addCmdNone

        KeyMsg keyCode ->
            let
                searchResults =
                    getSearchResults model.searchInput model.terms

                resultsLength =
                    List.length searchResults
            in
                case keyCode of
                    -- up
                    38 ->
                        let
                            newIndex =
                                if model.selectedTermIndex > 0 then
                                    model.selectedTermIndex - 1
                                else
                                    0
                        in
                            { model | selectedTermIndex = newIndex }
                                |> addCmdNone

                    -- down
                    40 ->
                        let
                            newIndex =
                                if model.selectedTermIndex < resultsLength - 1 then
                                    model.selectedTermIndex + 1
                                else
                                    resultsLength - 1
                        in
                            { model | selectedTermIndex = newIndex }
                                |> addCmdNone

                    -- enter
                    13 ->
                        let
                            selectedTerm =
                                getAtIndex model.selectedTermIndex searchResults
                        in
                            case selectedTerm of
                                Nothing ->
                                    model
                                        |> addCmdNone

                                Just term ->
                                    let
                                        newDisplayedTerm =
                                            getNewDisplayedTerm model.displayedTerm term
                                    in
                                        { model | displayedTerm = newDisplayedTerm }
                                            |> addCmdNone

                    _ ->
                        model
                            |> addCmdNone



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.downs KeyMsg



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
        , subscriptions = subscriptions
        }

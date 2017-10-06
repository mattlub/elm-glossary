module Main exposing (..)

import Html exposing (Html, div, h1, h3, ul, li, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Model exposing (TechnicalTerm, Model)
import Data exposing (initialModel)


-- VIEW


createSearchResult : TechnicalTerm -> Html Msg
createSearchResult term =
    li [ class "results-li", onClick (ClickTerm term) ] [ text term.text ]


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
                [ text term.text
                , div []
                    [ h3 [] [ text "English" ]
                    , text term.english
                    ]
                , div []
                    [ h3 [] [ text "Arabic" ]
                    , text term.arabic
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
        [ h3 [] [ text "Search" ]
        , input [ class "search-input", onInput ChangeSearchInput, value model.searchInput ] []
        , ul [ class "results-list" ]
            (List.filter (containsString model.searchInput) model.terms
                |> List.sortWith (startsWithComesFirst model.searchInput)
                |> List.map createSearchResult
            )
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Founders and Coders Glossary" ]
        , div [ class "content" ]
            [ searchSection model
            , wordDisplaySection model.displayedWord
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

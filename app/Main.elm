module Main exposing (..)

import Html exposing (Html, button, div, h1, h3, ul, li, input, label, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


-- MODEL


type alias TechnicalTerm =
    { text : String
    , english : String
    , arabic : String
    }


type alias Model =
    { terms : List TechnicalTerm
    , searchInput : String
    , displayedWord : Maybe TechnicalTerm
    }



-- VIEW


createSearchResult : TechnicalTerm -> Html Msg
createSearchResult term =
    li [] [ text term.text ]


containsString : String -> TechnicalTerm -> Bool
containsString string term =
    String.contains string term.text


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
            model
                |> addCmdNone



-- INIT


model : Model
model =
    { terms =
        [ { text = "full-stack"
          , english = "The whole technology stack for an application, including the front-end, back-end and database technology. For example, a full-stack developer might use the MEAN stack, which is MongoDB, Express, Angular and Node."
          , arabic = ""
          }
        , { text = "browser (as in web browser)"
          , english = "A program which allows users to browse web pages. For example, Google Chrome or Mozilla Firefox."
          , arabic = "This text should be arabic"
          }
        ]
    , searchInput = ""
    , displayedWord = Nothing
    }


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

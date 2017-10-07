module Model exposing (..)

-- MODEL


type alias TechnicalTerm =
    { text : String
    , english : String
    , arabic : String
    }


type alias Model =
    { terms : List TechnicalTerm
    , searchInput : String
    , displayedTerm : Maybe TechnicalTerm
    , selectedTermIndex : Int
    }

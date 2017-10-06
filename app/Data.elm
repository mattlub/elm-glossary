module Data exposing (..)

import Model exposing (Model)


initialModel : Model
initialModel =
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

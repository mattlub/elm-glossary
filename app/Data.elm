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
        , { text = "front-end"
          , english = "The part of the application which the user sees and interacts which. For example, HTML, CSS, and Javascript are front-end technologies."
          , arabic = "الناصرة (بالآرامية: ܢܨܪܬ؛ باللاتينية: Nazara؛ بالعبرية: נָצְרַת) من أهم مدن فلسطين التاريخية، تقع اليوم في لواء الشمال الإسرائيلي في منطقة الجليل، وتبعد عن القدس حوالي 105 كم إلى الشمال."
          }
        , { text = "TDD (test-driven development)"
          , english = "test-driven development is a method of development where you write (failing) tests before writing the code to pass the tests."
          , arabic = ""
          }
        ]
    , searchInput = ""
    , displayedTerm = Nothing
    , selectedTermIndex = 0
    }

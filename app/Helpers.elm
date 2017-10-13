module Helpers exposing (..)

import Regex


splitOut : String -> String -> List String
splitOut delimiter string =
    String.split delimiter string
        |> List.intersperse delimiter


iContains : String -> String -> Bool
iContains str text =
    Regex.contains (Regex.regex str |> Regex.caseInsensitive) text

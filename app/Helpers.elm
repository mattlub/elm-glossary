module Helpers exposing (..)

import Regex


iContains : String -> String -> Bool
iContains str text =
    Regex.contains (Regex.regex str |> Regex.caseInsensitive) text


splitOut : String -> String -> List String
splitOut delimiter string =
    String.split delimiter string
        |> List.intersperse delimiter


iSplitOut : String -> String -> List String
iSplitOut test string =
    splitOut test string

module Tests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Helpers exposing (iContains, iSplitOut, splitOut)


suite : Test
suite =
    describe "The Helper Functions"
        [ describe "iContains"
            [ test "should work on normal true cases" <|
                \_ ->
                    iContains "te" "test"
                        |> Expect.equal True
            , test "should work on case insensitive true cases (1)" <|
                \_ ->
                    iContains "TeSt" "test"
                        |> Expect.equal True
            , test "should work on case insensitive true cases (2)" <|
                \_ ->
                    iContains "abc" "ABcdEF"
                        |> Expect.equal True
            , test "should work on false cases" <|
                \_ ->
                    iContains "false" "testString"
                        |> Expect.equal False
            ]
        , describe "splitOut"
            [ test "should work on case where string starts with search" <|
                \_ ->
                    splitOut "te" "test"
                        |> Expect.equal [ "te", "st" ]
            ]
        , describe "iSplitOut"
            [ test "should work on empty string search case" <|
                \_ ->
                    iSplitOut "" "HI"
                        |> Expect.equal [ "H", "", "I" ]
            , test "should work on basic cases" <|
                \_ ->
                    iSplitOut "t" "atata"
                        |> Expect.equal [ "a", "t", "a", "t", "a" ]
            , test "should work on case insensitive cases" <|
                \_ ->
                    iSplitOut "aB" "ABXab"
                        |> Expect.equal [ "", "AB", "X", "ab", "" ]
            ]
        ]

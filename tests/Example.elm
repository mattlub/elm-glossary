module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Helpers exposing (iContains)


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
        ]

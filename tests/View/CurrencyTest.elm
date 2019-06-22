module View.CurrencyTest exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import View.Currency as Currency


suite : Test
suite =
    describe "The View.Currency module"
        [ describe "fromFloat"
            [ test "formats a float value with the doller sign" <|
                \_ ->
                    Currency.fromFloat 123.45
                        |> Expect.equal "$123.45"
            , test "pads zeros to the 2-digit decimal part" <|
                \_ ->
                    Currency.fromFloat 123.4
                        |> Expect.equal "$123.40"
            , test "appends two zeros for an integer value" <|
                \_ ->
                    Currency.fromFloat 123
                        |> Expect.equal "$123.00"
            , test "inserts commas between every three digits" <|
                \_ ->
                    Currency.fromFloat 1234567.89
                        |> Expect.equal "$1,234,567.89"
            , test "rounds .004 down" <|
                \_ ->
                    Currency.fromFloat 123.004
                        |> Expect.equal "$123.00"
            , test "rounds .005 up" <|
                \_ ->
                    Currency.fromFloat 123.005
                        |> Expect.equal "$123.01"
            ]
        ]

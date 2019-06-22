module View.Currency exposing (fromFloat)

import String.Extra as String


fromFloat : Float -> String
fromFloat value =
    let
        ( intPart, decimalPart ) =
            format 2 value
    in
    "$" ++ intPart ++ "." ++ decimalPart


format : Int -> Float -> ( String, String )
format digits value =
    let
        rounded =
            String.fromFloat <| roundAt digits value

        intPart =
            if String.isEmpty (String.leftOf "." rounded) then
                rounded

            else
                String.leftOf "." rounded

        insertCommas =
            String.reverse << String.wrapWith 3 "," << String.reverse

        decimalPart =
            String.padRight digits '0' <| String.rightOf "." rounded
    in
    ( insertCommas intPart, decimalPart )


roundAt : Int -> Float -> Float
roundAt digits value =
    let
        factor =
            toFloat (10 ^ digits)
    in
    toFloat (round (value * factor)) / factor

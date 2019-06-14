module Subscriptions exposing (subscriptions)

import Json.Decode as D
import Model exposing (Model, Msg(..), Product)
import Port


subscriptions : Model -> Sub Msg
subscriptions model =
    productsSub model


productsSub : Model -> Sub Msg
productsSub _ =
    Port.setProducts <| productsHandler << Port.decodeProducts


productsHandler : Result D.Error (List Product) -> Msg
productsHandler result =
    case result of
        Ok products ->
            SetProducts products

        Err error ->
            ShowDecodeError error

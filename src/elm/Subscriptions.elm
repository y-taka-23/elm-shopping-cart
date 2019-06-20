module Subscriptions exposing (subscriptions)

import Json.Decode as D
import Model exposing (CheckoutStatus, Model, Msg(..), Product)
import Port


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ productsSub model, checkoutStatusSub model ]


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


checkoutStatusSub : Model -> Sub Msg
checkoutStatusSub _ =
    Port.setCheckoutStatus <|
        checkoutStatusHandler
            << Port.decodeCheckoutStatus


checkoutStatusHandler : Result D.Error CheckoutStatus -> Msg
checkoutStatusHandler result =
    case result of
        Ok status ->
            SetCheckoutStatus status

        Err error ->
            ShowDecodeError error

port module Port exposing
    ( checkout
    , decodeCheckoutStatus
    , decodeProducts
    , encodeCart
    , fetchProducts
    , setCheckoutStatus
    , setProducts
    )

import Json.Decode as D
import Json.Encode as E
import Model exposing (Cart, CheckoutStatus(..), Product)


port fetchProducts : () -> Cmd msg


port setProducts : (D.Value -> msg) -> Sub msg


port checkout : E.Value -> Cmd msg


port setCheckoutStatus : (D.Value -> msg) -> Sub msg


decodeProducts : D.Value -> Result D.Error (List Product)
decodeProducts =
    let
        decoder =
            D.map4 Product
                (D.field "id" D.int)
                (D.field "title" D.string)
                (D.field "price" D.float)
                (D.field "inventory" D.int)
    in
    D.decodeValue (D.list decoder)


encodeCart : Cart -> E.Value
encodeCart =
    E.dict String.fromInt E.int


decodeCheckoutStatus : D.Value -> Result D.Error CheckoutStatus
decodeCheckoutStatus =
    let
        toStatus cond =
            if cond then
                Success

            else
                Fail
    in
    Result.map toStatus << D.decodeValue D.bool

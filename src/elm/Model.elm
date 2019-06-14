module Model exposing
    ( Cart
    , CartItem
    , CheckoutStatus(..)
    , Model
    , Msg(..)
    , Product
    , initModel
    , listCartItems
    )

import Dict exposing (Dict)
import Json.Decode as D
import List.Extra as List
import Maybe.Extra as Maybe


type Msg
    = SetProducts (List Product)
    | ShowDecodeError D.Error


type alias Model =
    { products : List Product
    , loading : Bool
    , cart : Cart
    , checkoutStatus : Maybe CheckoutStatus
    }


type alias Product =
    { id : ProductId
    , title : String
    , price : Float
    , inventory : Quantity
    }


type alias ProductId =
    Int


type alias Quantity =
    Int


type alias Cart =
    Dict ProductId Quantity


type alias CartItem =
    { id : ProductId
    , title : String
    , price : Float
    , quantity : Quantity
    }


type CheckoutStatus
    = Success
    | Fail


initModel : Model
initModel =
    { products = []
    , loading = True
    , cart = Dict.fromList []
    , checkoutStatus = Nothing
    }


listCartItems : List Product -> Cart -> List CartItem
listCartItems products cart =
    let
        toCartItem ( id, quantity ) =
            case findProduct products id of
                Nothing ->
                    Nothing

                Just product ->
                    Just
                        { id = product.id
                        , title = product.title
                        , price = product.price
                        , quantity = quantity
                        }
    in
    Maybe.values <| List.map toCartItem <| Dict.toList cart


findProduct : List Product -> ProductId -> Maybe Product
findProduct products id =
    List.find (\p -> p.id == id) products

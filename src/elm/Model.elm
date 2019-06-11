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
import List.Extra as List
import Maybe.Extra as Maybe


type Msg
    = NoOp


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
    { products =
        [ { id = 1, title = "iPad 4 Mini", price = 500.01, inventory = 1 }
        , { id = 2, title = "H&M T-Shirt White", price = 10.99, inventory = 10 }
        , { id = 3, title = "Charli XCX - Sucker CD", price = 19.99, inventory = 0 }
        ]
    , loading = False
    , cart =
        Dict.fromList
            [ ( 1, 1 )
            , ( 3, 5 )
            ]
    , checkoutStatus = Just Success
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

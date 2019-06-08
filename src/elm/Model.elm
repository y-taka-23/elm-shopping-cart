module Model exposing
    ( Cart
    , CartItem
    , CheckoutStatus(..)
    , Model
    , Msg(..)
    , Product
    , initModel
    )

import Dict exposing (Dict)


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
    { products = []
    , loading = True
    , cart = Dict.empty
    , checkoutStatus = Nothing
    }

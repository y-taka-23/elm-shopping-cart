module Model exposing
    ( Cart
    , CartItem
    , CheckoutStatus(..)
    , Model
    , Msg(..)
    , Product
    , ProductId
    , Quantity
    , decrementCart
    , decrementStock
    , flushCart
    , incrementCart
    , incrementStock
    , initModel
    , isEmpty
    , isInCart
    , isInStock
    , listCartItems
    )

import Dict exposing (Dict)
import Json.Decode as D
import List.Extra as List
import Maybe.Extra as Maybe


type Msg
    = SetProducts (List Product)
    | AddToCart ProductId
    | RemoveFromCart ProductId
    | Checkout
    | SetCheckoutStatus CheckoutStatus
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


isInStock : List Product -> ProductId -> Bool
isInStock products id =
    case findProduct products id of
        Nothing ->
            False

        Just product ->
            product.inventory > 0


isInCart : Cart -> ProductId -> Bool
isInCart cart id =
    case Dict.get id cart of
        Nothing ->
            False

        Just quantity ->
            quantity > 0


isEmpty : Cart -> Bool
isEmpty cart =
    List.all ((>=) 0) <| List.map Tuple.second <| Dict.toList cart


decrementStock : List Product -> ProductId -> List Product
decrementStock products id =
    List.updateIf (\p -> p.id == id)
        (\p -> { p | inventory = max 0 (p.inventory - 1) })
        products


incrementStock : List Product -> ProductId -> List Product
incrementStock products id =
    List.updateIf (\p -> p.id == id)
        (\p -> { p | inventory = p.inventory + 1 })
        products


incrementCart : Cart -> ProductId -> Cart
incrementCart cart id =
    case Dict.get id cart of
        Nothing ->
            Dict.insert id 1 cart

        Just quantity ->
            Dict.insert id (quantity + 1) cart


decrementCart : Cart -> ProductId -> Cart
decrementCart cart id =
    case Dict.get id cart of
        Nothing ->
            cart

        Just 1 ->
            Dict.remove id cart

        Just quantity ->
            Dict.insert id (quantity - 1) cart


flushCart : Cart -> Cart
flushCart _ =
    Dict.empty

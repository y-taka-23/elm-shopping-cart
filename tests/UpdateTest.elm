module UpdateTest exposing (suite)

import Dict
import Expect
import Fuzz
    exposing
        ( Fuzzer
        , bool
        , constant
        , float
        , int
        , intRange
        , list
        , maybe
        , oneOf
        , string
        )
import List.Extra as List
import Model
    exposing
        ( Cart
        , CheckoutStatus(..)
        , Model
        , Msg(..)
        , Product
        , ProductId
        , Quantity
        )
import Random exposing (maxInt)
import Test exposing (Test, describe, fuzz, fuzz2, test)
import Update


totalNum : List Product -> Cart -> ProductId -> Int
totalNum products cart id =
    let
        stockNum =
            Maybe.withDefault 0 <|
                Maybe.map (\p -> p.inventory) <|
                    List.find (\p -> p.id == id) products

        cartNum =
            Maybe.withDefault 0 <| Dict.get id cart
    in
    stockNum + cartNum


model : Fuzzer Model
model =
    Fuzz.map3 mkModel consistentCart bool (maybe checkoutStatus)


mkModel : ( List Product, Cart ) -> Bool -> Maybe CheckoutStatus -> Model
mkModel ( products, cart ) loading status =
    { products = products
    , loading = loading
    , cart = cart
    , checkoutStatus = status
    }


consistentCart : Fuzzer ( List Product, Cart )
consistentCart =
    Fuzz.map3 mkConsistentCart (list product) (list quantity) (list bool)


mkConsistentCart :
    List Product
    -> List Quantity
    -> List Bool
    -> ( List Product, Cart )
mkConsistentCart products quantities mask =
    let
        ids =
            List.map (\p -> p.id) products

        pairs =
            List.map2 Tuple.pair ids quantities

        masked =
            List.map Tuple.first <|
                List.filter Tuple.second <|
                    List.map2 Tuple.pair pairs mask
    in
    ( products, Dict.fromList masked )


product : Fuzzer Product
product =
    Fuzz.map4 Product int string float quantity


quantity : Fuzzer Quantity
quantity =
    intRange 0 maxInt


checkoutStatus : Fuzzer CheckoutStatus
checkoutStatus =
    oneOf [ constant Success, constant Fail ]


suite : Test
suite =
    describe "The Update model"
        [ describe "update by AddToCart"
            [ fuzz2 model int "preserves the total number of products" <|
                \original id ->
                    let
                        updated =
                            Tuple.first <| Update.update (AddToCart id) original
                    in
                    Expect.equal
                        (totalNum updated.products updated.cart id)
                        (totalNum original.products original.cart id)
            , test "does nothing if the product is out of stock" <|
                \_ ->
                    let
                        original =
                            { products =
                                [ { id = 1, title = "A", price = 100, inventory = 0 }
                                ]
                            , loading = False
                            , cart = Dict.fromList [ ( 1, 15 ) ]
                            , checkoutStatus = Nothing
                            }
                    in
                    original
                        |> Update.update (AddToCart 1)
                        |> Tuple.first
                        |> Expect.equal original
            ]
        , describe "update by RemoveFromCart"
            [ fuzz2 model int "preserves the total number of products" <|
                \original id ->
                    let
                        updated =
                            Tuple.first <| Update.update (RemoveFromCart id) original
                    in
                    Expect.equal
                        (totalNum updated.products updated.cart id)
                        (totalNum original.products original.cart id)
            , test "does nothing if the item is not in the cart" <|
                \_ ->
                    let
                        original =
                            { products =
                                [ { id = 1, title = "A", price = 100, inventory = 10 }
                                ]
                            , loading = False
                            , cart = Dict.fromList [ ( 1, 0 ) ]
                            , checkoutStatus = Nothing
                            }
                    in
                    original
                        |> Update.update (RemoveFromCart 1)
                        |> Tuple.first
                        |> Expect.equal original
            ]
        , describe "update by SetCheckoutStatus"
            [ fuzz model "empties the cart if the status is Success" <|
                \original ->
                    original
                        |> Update.update (SetCheckoutStatus Success)
                        |> Tuple.first
                        |> (\m -> m.cart)
                        |> Expect.equal Dict.empty
            , fuzz model "preserves the cart if the status is Fail" <|
                \original ->
                    original
                        |> Update.update (SetCheckoutStatus Fail)
                        |> Tuple.first
                        |> (\m -> m.cart)
                        |> Expect.equal original.cart
            ]
        ]

module ModelTest exposing (suite)

import Dict
import Expect
import Model
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "The Model module"
        [ describe "listCartItems" <|
            let
                products =
                    [ { id = 1, title = "A", price = 100, inventory = 10 }
                    , { id = 2, title = "B", price = 200, inventory = 20 }
                    , { id = 3, title = "C", price = 300, inventory = 30 }
                    ]
            in
            [ test "maps the empty cart to the empty list" <|
                \_ ->
                    Dict.fromList []
                        |> Model.listCartItems products
                        |> Expect.equal []
            , test "joins the cart with the products by their ids " <|
                \_ ->
                    Dict.fromList [ ( 1, 15 ), ( 3, 35 ) ]
                        |> Model.listCartItems products
                        |> Expect.equal
                            [ { id = 1, title = "A", price = 100, quantity = 15 }
                            , { id = 3, title = "C", price = 300, quantity = 35 }
                            ]
            , test "ignores if the id is missing" <|
                \_ ->
                    Dict.fromList [ ( 1, 15 ), ( 4, 45 ) ]
                        |> Model.listCartItems products
                        |> Expect.equal
                            [ { id = 1, title = "A", price = 100, quantity = 15 }
                            ]
            ]
        , describe "isInStock" <|
            let
                products =
                    [ { id = 1, title = "A", price = 100, inventory = 10 }
                    , { id = 2, title = "B", price = 200, inventory = 0 }
                    ]
            in
            [ test "returns True if you have the product in stock" <|
                \_ ->
                    Model.isInStock products 1
                        |> Expect.true "the product 1 should be in stock"
            , test "returns False if the products is out of stock" <|
                \_ ->
                    Model.isInStock products 2
                        |> Expect.false "the product 2 shouldn't be in stock"
            , test "returns False if the product is missing" <|
                \_ ->
                    Model.isInStock products 3
                        |> Expect.false "the product 3 shouldn't be in stock"
            ]
        , describe "isInCart" <|
            let
                cart =
                    Dict.fromList [ ( 1, 15 ), ( 2, 0 ) ]
            in
            [ test "returns True if you have the item in the cart" <|
                \_ ->
                    Model.isInCart cart 1
                        |> Expect.true "the item 1 should be in the cart"
            , test "returns False if you don't have the item in the cart" <|
                \_ ->
                    Model.isInCart cart 2
                        |> Expect.false "the item 2 shouldn't be in the cart"
            , test "returns False if the item is missing" <|
                \_ ->
                    Model.isInCart cart 3
                        |> Expect.false "the item 3 shouldn't be in the cart"
            ]
        , describe "isEmpty" <|
            [ test "returns True if the cart has no item" <|
                \_ ->
                    Dict.fromList []
                        |> Model.isEmpty
                        |> Expect.true "the empty cart has no item"
            , test "returns False if the cart has a item of positive quantity" <|
                \_ ->
                    Dict.fromList [ ( 1, 15 ) ]
                        |> Model.isEmpty
                        |> Expect.false "the item 1 should be in the cart"
            , test "returns True if the cart has a item of zero quantity" <|
                \_ ->
                    Dict.fromList [ ( 1, 0 ) ]
                        |> Model.isEmpty
                        |> Expect.true "the item 1 is registered but has quantity zero"
            ]
        , describe "decrementStock" <|
            let
                products =
                    [ { id = 1, title = "A", price = 100, inventory = 10 }
                    , { id = 2, title = "B", price = 200, inventory = 0 }
                    ]
            in
            [ test "decrements the stock if you have" <|
                \_ ->
                    Model.decrementStock products 1
                        |> Expect.equal
                            [ { id = 1, title = "A", price = 100, inventory = 9 }
                            , { id = 2, title = "B", price = 200, inventory = 0 }
                            ]
            , test "does nothing if the product is out of stock" <|
                \_ ->
                    Model.decrementStock products 2
                        |> Expect.equal products
            , test "does nothing if the product is mising" <|
                \_ ->
                    Model.decrementStock products 3
                        |> Expect.equal products
            ]
        , describe "incrementStock" <|
            let
                products =
                    [ { id = 1, title = "A", price = 100, inventory = 10 }
                    , { id = 2, title = "B", price = 200, inventory = 0 }
                    ]
            in
            [ test "increments the stock if you have" <|
                \_ ->
                    Model.incrementStock products 1
                        |> Expect.equal
                            [ { id = 1, title = "A", price = 100, inventory = 11 }
                            , { id = 2, title = "B", price = 200, inventory = 0 }
                            ]
            , test "does nothing if the product is mising" <|
                \_ ->
                    Model.incrementStock products 3
                        |> Expect.equal products
            ]
        , describe "incrementCart" <|
            let
                cart =
                    Dict.fromList [ ( 1, 10 ) ]
            in
            [ test "increments the item in the cart " <|
                \_ ->
                    Model.incrementCart cart 1
                        |> Expect.equal
                            (Dict.fromList [ ( 1, 11 ) ])
            , test "registers a new item if it's missing" <|
                \_ ->
                    Model.incrementCart cart 2
                        |> Expect.equal
                            (Dict.fromList [ ( 1, 10 ), ( 2, 1 ) ])
            ]
        , describe "decrementCart" <|
            let
                cart =
                    Dict.fromList [ ( 1, 10 ), ( 2, 1 ) ]
            in
            [ test "decrements the item in the cart " <|
                \_ ->
                    Model.decrementCart cart 1
                        |> Expect.equal
                            (Dict.fromList [ ( 1, 9 ), ( 2, 1 ) ])
            , test "unregisters the item if it's the last one" <|
                \_ ->
                    Model.decrementCart cart 2
                        |> Expect.equal
                            (Dict.fromList [ ( 1, 10 ) ])
            ]
        , describe "flushCart" <|
            [ test "unregisters all items from the cart" <|
                \_ ->
                    Dict.fromList [ ( 1, 15 ), ( 2, 0 ) ]
                        |> Model.flushCart
                        |> Expect.equal Dict.empty
            ]
        ]

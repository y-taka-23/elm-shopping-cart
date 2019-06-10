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
        ]

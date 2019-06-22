module View.ShoppingCart exposing (view)

import Dict
import Html exposing (Html, button, div, h2, h3, li, span, text, ul)
import Html.Attributes exposing (class, disabled)
import Html.Events exposing (onClick)
import Model
    exposing
        ( CartItem
        , Model
        , Msg(..)
        , Product
        , isEmpty
        , isInStock
        , listCartItems
        )


view : Model -> Html Msg
view model =
    div
        [ class "w-64 ml-auto mt-6 mb-auto"
        , class "border rounded"
        , class "flex flex-col"
        ]
        [ h2
            [ class "px-4 py-2"
            , class "border-b"
            , class "bg-gray-200"
            ]
            [ text "Shopping Cart" ]
        , ul [] <|
            List.map (viewCartItem model.products) <|
                listCartItems model.products model.cart
        , div
            [ class "px-4 pt-2"
            , class "font-bold"
            , class "flex flex-row"
            ]
            [ span [] [ text "Total: " ]
            , span [ class "ml-auto" ]
                [ text <|
                    String.fromFloat <|
                        totalCartItems <|
                            listCartItems model.products model.cart
                ]
            ]
        , button
            ([ class "m-4 px-4 py-2"
             , class "bg-green-500"
             , class "rounded"
             , class "text-white"
             ]
                ++ (if isEmpty model.cart then
                        [ disabled True
                        , class "opacity-50 cursor-not-allowed"
                        ]

                    else
                        [ class "hover:bg-green-700"
                        , onClick Checkout
                        ]
                   )
            )
            [ text "Checkout" ]
        ]


viewCartItem : List Product -> CartItem -> Html Msg
viewCartItem products item =
    li [ class "px-4 py-2" ]
        [ h3 [ class "pb-1" ]
            [ text <| String.fromInt item.quantity ++ " x " ++ item.title ]
        , div [ class "flex flex-row" ]
            [ button
                ([ class "my-auto px-3 py-1"
                 , class "rounded-l"
                 , class "bg-blue-500"
                 , class "text-white"
                 ]
                    ++ (if isInStock products item.id then
                            [ class "hover:bg-blue-700"
                            , onClick <| AddToCart item.id
                            ]

                        else
                            [ class "opacity-50 cursor-not-allowed"
                            , disabled True
                            ]
                       )
                )
                [ text "+" ]
            , button
                [ class "my-auto px-3 py-1"
                , class "rounded-r"
                , class "bg-gray-500 hover:bg-gray-700"
                , class "text-white"
                , onClick <| RemoveFromCart item.id
                ]
                [ text "-" ]
            , span [ class "my-auto ml-auto" ]
                [ text <| String.fromFloat <| subtotalCartItem item ]
            ]
        ]


totalCartItems : List CartItem -> Float
totalCartItems =
    List.sum << List.map subtotalCartItem


subtotalCartItem : CartItem -> Float
subtotalCartItem item =
    item.price * toFloat item.quantity

module View.ShoppingCart exposing (view)

import Dict
import Html exposing (Html, button, div, h2, h3, li, span, text, ul)
import Html.Attributes exposing (class)
import Model exposing (CartItem, Model, Msg, listCartItems)


view : Model -> Html Msg
view model =
    div
        [ class "w-64 ml-auto my-6"
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
            List.map viewCartItem <|
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
            [ class "m-4 px-4 py-2"
            , class "bg-green-500 hover:bg-green-700"
            , class "rounded"
            , class "text-white"
            ]
            [ text "Checkout" ]
        ]


viewCartItem : CartItem -> Html Msg
viewCartItem item =
    li [ class "px-4 py-2" ]
        [ h3 [ class "pb-1" ]
            [ text <| String.fromInt item.quantity ++ " x " ++ item.title ]
        , div [ class "flex flex-row" ]
            [ button
                [ class "my-auto px-3 py-1"
                , class "rounded-l"
                , class "bg-blue-500"
                , class "text-white"
                ]
                [ text "+" ]
            , button
                [ class "my-auto px-3 py-1"
                , class "rounded-r"
                , class "bg-gray-500"
                , class "text-white"
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

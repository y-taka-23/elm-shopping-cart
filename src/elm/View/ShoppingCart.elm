module View.ShoppingCart exposing (view)

import Dict
import Html exposing (Html, button, div, h2, h3, li, text, ul)
import Model exposing (CartItem, Model, Msg, listCartItems)


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Shopping Cart" ]
        , ul [] <|
            List.map viewCartItem <|
                listCartItems model.products model.cart
        , div []
            [ text "Total: "
            , text <|
                String.fromFloat <|
                    totalCartItems <|
                        listCartItems model.products model.cart
            ]
        , button [] [ text "Checkout" ]
        ]


viewCartItem : CartItem -> Html Msg
viewCartItem item =
    li []
        [ h3 [] [ text <| String.fromInt item.quantity ++ " x " ++ item.title ]
        , button [] [ text "+" ]
        , button [] [ text "-" ]
        , text <| String.fromFloat <| subtotalCartItem item
        ]


totalCartItems : List CartItem -> Float
totalCartItems =
    List.sum << List.map subtotalCartItem


subtotalCartItem : CartItem -> Float
subtotalCartItem item =
    item.price * toFloat item.quantity

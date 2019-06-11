module View exposing (view)

import Html exposing (Html, button, div, h1, nav, text)
import Model exposing (CheckoutStatus(..), Model, Msg)
import View.ProductList as ProductList
import View.ShoppingCart as ShoppingCart


view : Model -> Html Msg
view model =
    div []
        [ viewNav model.checkoutStatus
        , div []
            [ ProductList.view model
            , ShoppingCart.view model
            ]
        ]


viewNav : Maybe CheckoutStatus -> Html Msg
viewNav status =
    nav [] <|
        [ h1 [] [ text "Shopping Cart Example" ] ]
            ++ viewAlert status


viewAlert : Maybe CheckoutStatus -> List (Html Msg)
viewAlert status =
    case status of
        Nothing ->
            []

        Just Success ->
            [ div []
                [ text "Successfully checked out."
                , button [] [ text "close" ]
                ]
            ]

        Just Fail ->
            [ div []
                [ text "Failed to check out. Try again."
                , button [] [ text "close" ]
                ]
            ]

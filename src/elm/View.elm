module View exposing (view)

import Html exposing (Html, button, div, h1, nav, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model exposing (CheckoutStatus(..), Model, Msg(..))
import View.ProductList as ProductList
import View.ShoppingCart as ShoppingCart


view : Model -> Html Msg
view model =
    div [ class "mx-8" ]
        [ viewNav model.checkoutStatus
        , div [ class "flex flex-row" ]
            [ ProductList.view model
            , ShoppingCart.view model
            ]
        ]


viewNav : Maybe CheckoutStatus -> Html Msg
viewNav status =
    nav
        [ class "h-20"
        , class "border-b"
        , class "flex flex-row"
        ]
    <|
        [ h1
            [ class "my-auto"
            , class "text-4xl"
            ]
            [ text "Shopping Cart Example" ]
        ]
            ++ viewAlert status


viewAlert : Maybe CheckoutStatus -> List (Html Msg)
viewAlert status =
    case status of
        Nothing ->
            []

        Just result ->
            let
                ( classes, contents ) =
                    case result of
                        Success ->
                            ( [ class "border-green-500"
                              , class "bg-green-100"
                              , class "text-green-500"
                              ]
                            , "Successfully checked.out."
                            )

                        Fail ->
                            ( [ class "border-red-500"
                              , class "bg-red-100"
                              , class "text-red-500"
                              ]
                            , "Failed to check out. Try again."
                            )
            in
            [ div
                ([ class "ml-auto my-auto pl-4 pr-2 py-2"
                 , class "border rounded rounded"
                 , class "flex flex-row"
                 ]
                    ++ classes
                )
                [ span [ class "mr-4 my-auto" ] [ text contents ]
                , button
                    [ class "material-icons my-auto"
                    , onClick UnsetCheckoutStatus
                    ]
                    [ text "close" ]
                ]
            ]

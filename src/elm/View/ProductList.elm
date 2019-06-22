module View.ProductList exposing (view)

import Html exposing (Html, button, div, h2, img, li, p, text, ul)
import Html.Attributes exposing (class, disabled, src)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(..), Product)
import View.Currency as Currency


view : Model -> Html Msg
view model =
    div []
        [ if model.loading then
            img
                [ class "px-40 py-10"
                , src "https://i.imgur.com/JfPpwOA.gif"
                ]
                []

          else
            ul [ class "flex flex-row" ] <| List.map viewProduct model.products
        ]


viewProduct : Product -> Html Msg
viewProduct product =
    li
        [ class "w-40 pr-4 py-6"
        , class "flex flex-col"
        ]
        [ h2
            [ class "mb-auto pb-2"
            , class "font-bold"
            ]
            [ text product.title ]
        , p [] [ text <| Currency.fromFloat product.price ]
        , p [] [ text <| "Stock: " ++ String.fromInt product.inventory ]
        , button
            ([ class "mt-4 mr-auto px-4 py-2"
             , class "bg-blue-500"
             , class "rounded"
             , class "text-white"
             ]
                ++ (if product.inventory > 0 then
                        [ class "hover:bg-blue-700"
                        , onClick <| AddToCart product.id
                        ]

                    else
                        [ class "opacity-50 cursor-not-allowed"
                        , disabled True
                        ]
                   )
            )
            [ text "Add to cart" ]
        ]

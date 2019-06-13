module View.ProductList exposing (view)

import Html exposing (Html, button, div, h2, li, p, text, ul)
import Html.Attributes exposing (class)
import Model exposing (Model, Msg, Product)


view : Model -> Html Msg
view model =
    div []
        [ ul [ class "flex flex-row" ] <| List.map viewProduct model.products ]


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
        , p [] [ text <| String.fromFloat product.price ]
        , p [] [ text <| "Stock: " ++ String.fromInt product.inventory ]
        , button
            [ class "mt-4 mr-auto px-4 py-2"
            , class "bg-blue-500 hover:bg-blue-700"
            , class "rounded"
            , class "text-white"
            ]
            [ text "Add to cart" ]
        ]

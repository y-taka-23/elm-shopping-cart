module View.ProductList exposing (view)

import Html exposing (Html, button, div, h2, li, p, text, ul)
import Model exposing (Model, Msg, Product)


view : Model -> Html Msg
view model =
    div []
        [ ul [] <| List.map viewProduct model.products ]


viewProduct : Product -> Html Msg
viewProduct product =
    li []
        [ h2 [] [ text product.title ]
        , p [] [ text <| String.fromFloat product.price ]
        , p [] [ text <| "Stock: " ++ String.fromInt product.inventory ]
        , button [] [ text "Add to cart" ]
        ]

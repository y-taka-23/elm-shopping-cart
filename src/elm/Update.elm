module Update exposing (update)

import Model
    exposing
        ( Model
        , Msg(..)
        , decrementStock
        , inStock
        , incrementCart
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetProducts products ->
            ( { model | products = products, loading = False }, Cmd.none )

        AddToCart id ->
            if inStock model.products id then
                ( { model
                    | products = decrementStock model.products id
                    , cart = incrementCart model.cart id
                  }
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        ShowDecodeError error ->
            Debug.todo "failed to decode a JSON"

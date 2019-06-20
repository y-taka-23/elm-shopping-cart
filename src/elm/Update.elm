module Update exposing (update)

import Command exposing (checkout)
import Model
    exposing
        ( CheckoutStatus(..)
        , Model
        , Msg(..)
        , decrementCart
        , decrementStock
        , flushCart
        , incrementCart
        , incrementStock
        , isEmpty
        , isInCart
        , isInStock
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetProducts products ->
            ( { model | products = products, loading = False }, Cmd.none )

        AddToCart id ->
            if isInStock model.products id then
                ( { model
                    | products = decrementStock model.products id
                    , cart = incrementCart model.cart id
                  }
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        RemoveFromCart id ->
            if isInCart model.cart id then
                ( { model
                    | products = incrementStock model.products id
                    , cart = decrementCart model.cart id
                  }
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        Checkout ->
            if not (isEmpty model.cart) then
                ( model, checkout model.cart )

            else
                ( model, Cmd.none )

        SetCheckoutStatus Success ->
            ( { model
                | cart = flushCart model.cart
                , checkoutStatus = Just Success
              }
            , Cmd.none
            )

        SetCheckoutStatus Fail ->
            ( { model | checkoutStatus = Just Fail }, Cmd.none )

        ShowDecodeError error ->
            Debug.todo "failed to decode a JSON"

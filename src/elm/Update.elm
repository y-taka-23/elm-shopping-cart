module Update exposing (update)

import Model exposing (Model, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetProducts products ->
            ( { model | products = products, loading = False }, Cmd.none )

        ShowDecodeError error ->
            Debug.todo "failed to decode a JSON"

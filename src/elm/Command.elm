module Command exposing (checkout, initCmd)

import Model exposing (Cart, Msg)
import Port


initCmd : Cmd Msg
initCmd =
    Port.fetchProducts ()


checkout : Cart -> Cmd Msg
checkout =
    Port.checkout << Port.encodeCart

module Command exposing (initCmd)

import Model exposing (Msg)
import Port


initCmd : Cmd Msg
initCmd =
    Port.fetchProducts ()

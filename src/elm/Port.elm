port module Port exposing (decodeProducts, fetchProducts, setProducts)

import Json.Decode as D
import Model exposing (Product)


port fetchProducts : () -> Cmd msg


port setProducts : (D.Value -> msg) -> Sub msg


decodeProducts : D.Value -> Result D.Error (List Product)
decodeProducts =
    let
        decoder =
            D.map4 Product
                (D.field "id" D.int)
                (D.field "title" D.string)
                (D.field "price" D.float)
                (D.field "inventory" D.int)
    in
    D.decodeValue (D.list decoder)

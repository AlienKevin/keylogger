module Main exposing (..)

import Browser
import Element as E
import Element.Input as Input
import Html exposing (Html)
import Html.Events
import Json.Decode as Decode
import Keyboard exposing (Key(..))


type alias Model =
    { text : String
    , keys : List Key
    }


init : ( Model, Cmd Msg )
init =
    ( { text = ""
      , keys = []
      }
    , Cmd.none
    )


type Msg
    = OnChange String
    | KeyPressed Keyboard.RawKey


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnChange newText ->
            ( { model
                | text = newText
              }
            , Cmd.none
            )

        KeyPressed rawKey ->
            let
                key =
                    Keyboard.oneOf
                        [ Keyboard.whitespaceKey
                        , Keyboard.editingKey
                        , Keyboard.modifierKey
                        , Keyboard.characterKeyOriginal
                        ]
                        rawKey

                _ =
                    Debug.log "rawKey" rawKey

                _ =
                    Debug.log "key" key
            in
            ( case key of
                Just k ->
                    { model | keys = k :: model.keys }

                Nothing ->
                    model
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    E.layout [] <|
        Input.text
            [ E.htmlAttribute <| Html.Events.on "keydown" (Decode.map KeyPressed Keyboard.eventKeyDecoder) ]
            { onChange = OnChange
            , text = model.text
            , placeholder = Just (Input.placeholder [] <| E.text "Enter text here...")
            , label = Input.labelHidden "Enter text here"
            }


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

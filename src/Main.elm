module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, p, button, blockquote)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Http
import HttpBuilder exposing (..)


---- MODEL ----


type alias Model =
    { joke : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "", fetchRandomJokeCmd )

---- UPDATE ----

type Msg
    = GetJoke
    | FetchRandomJokeComplete (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GetJoke ->
      ( model, fetchRandomJokeCmd )

    FetchRandomJokeComplete result ->
      fetchRandomJokeComplete model result


randomJokeUrl : String
randomJokeUrl =
  "https://icanhazdadjoke.com/"

fetchRandomJokeCmd : Cmd Msg
fetchRandomJokeCmd =
  HttpBuilder.get randomJokeUrl
    |> withHeader "Accept" "text/plain"
    |> withExpectString
    |> send FetchRandomJokeComplete

fetchRandomJokeComplete : Model -> Result Http.Error String -> ( Model, Cmd Msg )
fetchRandomJokeComplete model result =
  case result of
    Ok newJoke ->
      ( { model | joke = newJoke }, Cmd.none )
    Err _ ->
      ( model, Cmd.none )


---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ] [
      h1 [] [ text "Dad Jokes" ]
      , p [ class "text-center" ] [
         button [ class "btn btn-success", onClick GetJoke ] [ text "Get a Joke!" ]
      ]
      -- Blockquote with joke
      , blockquote [] [
        p [] [text model.joke]
      ]
    ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

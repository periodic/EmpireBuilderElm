module City.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import City.Model exposing (..)
import City.Update exposing (Action(..))
import Fixed exposing (..)
import Icons exposing (..)

cityDetail : Signal.Address Action -> City -> Html
cityDetail address city =
  div [ class "city-detail" ]
    [ h3 [ class "name" ] [ text city.name  ]
    , div [ class "metrics" ]
      [ p [ class "distance-penalty" ] 
        [ iconDistance
        , text <| asFixed 0 city.site.distance
        ]
      , p [ class "population" ]
        [ iconPopulation
        , text <| toString city.population
        ]
      , p [ class "food" ]
        [ iconFood
        , text << asFixed 0 <| city.food
        , text "/"
        , text << asFixed 0 <| nextBirth city
        , text "(+"
        , text << asFixed 1 <| city.foodPerSecond
        , text ")"
        ]
      , p [ class "unemployed" ]
        [ iconUnemployed
        , text << toString <| city.population - numWorking city
        ]
      ]
    ]

module View.City where

import Dict exposing (Dict)
import Maybe

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Data.Building
import Model.City exposing (..)
import Update.City exposing (Action(..))
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
        , text << toString <| numUnemployed city
        ]
      , buildingList address city.buildings city.workers
      ]
    ]


buildingList : Signal.Address Action -> Dict BuildingId Int -> Dict BuildingId Int -> Html
buildingList address buildings workers =
  div [ class "building-list" ]
    [ h4 [] [ text "Buildings" ]
    , table [] <| List.map (building address buildings workers) <| Dict.toList Data.Building.byId
    ]


building : Signal.Address Action -> Dict BuildingId Int -> Dict BuildingId Int -> (BuildingId, Building) -> Html
building address buildings workers (buildingId, building) =
  let workerCount = Maybe.withDefault 0 <| Dict.get buildingId workers
      buildingCount = Maybe.withDefault 0 <| Dict.get buildingId buildings
  in tr []
        [ td [] [ text building.name ]
        , td [] [ text <| toString buildingCount ]
        , td [] [ workerDetail address buildingId workerCount ]
        , td []
          [ button [ onClick address (Build buildingId) ]
            [ text <| "Build (" ++ toString (buildingCost building buildingCount) ++ ")" ]
          ]
        ]

workerDetail : Signal.Address Action -> BuildingId -> Int -> Html
workerDetail address buildingId count =
  div [ class "workers" ]
    [ button [ onClick address (UnassignWorker buildingId) ] [ iconRemoveWorker ]
    , text (toString count)
    , button [ onClick address (AssignWorker buildingId) ] [ iconAddWorker ]
    ]

module View where

import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model.City exposing (City)
import Model.City as City
import View.City exposing (cityDetail)
import Empire exposing (Empire)
import Fixed exposing (..)
import Icons exposing (..)
import Model exposing (Model(..), View(..))
import Update exposing (Action(..))

-- TODO(periodic): remove this once these functions have been moved into a model module.
import Update.City as City

view : Signal.Address Action -> Model -> Html
view address model =
  let (Model _ {empire}) = model
  in div [ id "game", class "container" ]
    [ statusBar address empire
    , mainView address model
    ]

statusBar : Signal.Address Action -> Empire -> Html
statusBar address empire =
  div [ id "status-bar", class "row" ]
    [ ul [ class "menu" ]
      [ li [] [ text "Cities" ]
      , li [] [ text "Upgrades" ]
      , li [] [ text "Achievements" ]
      , li [] [ text "Settings" ]
      ]
    , div [ class "resources" ]
      [ div [ class "money" ]
        [ text "Money: "
        , text <| asFixed 0 empire.money
        , text " "
        , span [ class "income" ] [ text "(", text <| asFixed 2 empire.moneyPerSecond, text "/s)"]
        ]
      , div [ class "exploration" ]
        [ text "Exploration: "
        , text <| asFixed 0 empire.exploration
        , text " "
        , span [ class "income" ] [ text "(", text <| asFixed 2 empire.explorationPerSecond, text "/s)" ]
        ]
      , div [ class "score" ]
        [ text "Score: "
        , text <| toString empire.achievementScore
        ]
      ]
    ]

mainView : Signal.Address Action -> Model -> Html
mainView address (Model view {empire}) =
  div [ id "main" ]
    [ case view of
        CityList        -> cityListView address empire.cities
        CityDetails idx ->
          case List.head <| List.drop idx empire.cities of
            Just city -> cityDetailsView address empire.cities city
            Nothing -> Debug.log "Got invalid city index in view ."
                                 <| cityListView address empire.cities
        Upgrades        -> upgradesView address
        Achievements    -> achievementsView address
        Settings        -> settingsView address
    ]

cityListView : Signal.Address Action -> List City -> Html
cityListView address cities  =
  div []
    [ h2 [] [ text "Cities" ]
    , div [ class "row" ]
      [ cityList address cities
      ]
    ]

cityDetailsView : Signal.Address Action -> List City -> City -> Html
cityDetailsView address cities city =
  div []
    [ h2 [] [ text "Cities" ]
    , div [ class "row" ]
      [ cityList address cities
      , cityDetail address city
      ]
    ]

upgradesView : Signal.Address Action -> Html
upgradesView address = text "Upgrades here."

achievementsView : Signal.Address Action -> Html
achievementsView address = text "Achievements here."

settingsView : Signal.Address Action -> Html
settingsView address = text "Settings here."

cityList : Signal.Address Action -> List City -> Html
cityList address cities =
  div [ id "side-panel", class "col-md-5" ]
    [ table [ class "city-list table table-bordered table-hover table-condensed" ]
      [ thead []
        [ tr [ class "city-list-header" ]
          [ th [ class "name" ] [ text "City" ]
          , th [ class "population" ] [ iconPopulation ]
          , th [ class "buildings" ] [ iconBuildings ]
          , th [ class "money-delta" ] [ iconMoney ]
          , th [ class "exploration-delta" ] [ iconExploration ]
          , th [ class "unemployed" ] [ iconUnemployed ]
          ]
        ]
      , tbody [] (List.indexedMap (cityListLine address) cities)
      ]
    ]

cityListLine : Signal.Address Action -> Int -> City -> Html
cityListLine address index city =
  tr [ onClick address (ShowCityDetails index) ]
    [ td [ class "name" ]
      ( text city.name :: if City.isCapitol city then [ iconCapitol ] else [])
    , td [ class "population" ] [ text << toString <| city.population ]
    , td [ class "buildings" ] [ text << toString <| City.numBuildings city ]
    , td [ class "money-delta" ] [ text << asFixed 2 <| city.moneyPerSecond ]
    , td [ class "exploration-delta" ] [ text << asFixed 2 <| city.explorationPerSecond ]
    , td [ class "unemployed" ] [ text << toString <| City.numUnemployed city ]
    ]

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
        , text << asFixed 0 <| City.nextBirth city
        , text "(+"
        , text << asFixed 1 <| city.foodPerSecond
        , text ")"
        ]
      , p [ class "unemployed" ]
        [ iconUnemployed
        , text << toString <| city.population - City.numWorking city
        ]
      ]
    ]

{-
    , div [ class "modifiers" ] ng-if="hasModifiers()">
      , table [ class "table modifier-list" ]>
        , thead>
          , tr [ class "modifier-list-header" ]>
            , th simple-tooltip="The name of the modifier.">Modifier]
            , th simple-tooltip="A measure of how large a bonus this modifier provides.">Strength]
            , th>Description]
          ]
        ]
        , tbody>
          , tr ng-repeat="modifier in getModifiers()">
            , td>[  getModifierName(modifier)  ]]
            , td>[  getModifierStrength(modifier) | number:0  ]]
            , td>[  getModifierDescription(modifier)  ]]
          ]
        ]
      ]
    ] -}

{-
    , table [ class "building-list table" ]>
      , thead>
        , tr [ class "building-list-header" ]>
          , th [ class "name" ]>Building]
          , th [ class "count" ] simple-tooltip="The number of buildings built."><iconBuildings]
          , th [ class "workers" ] simple-tooltip="The number of citizens working at this building."><iconWorkers]
          , th [ class "description" ]>Description]
          , th [ class "actions" ]>]
        ]
      ]
      , tbody>
        , tr ng-repeat="building in getBuildings()">
          , td [ class "name" ]>[  building.name  ]]
          , td [ class "count" ]>[  getBuildingCount(building.id) | number:0  ]]
          , td [ class "workers" ]>
            , a ng-click="city.addWorker(building.id)">
              , icon-add-worker></icon-add-worker>
            ]
            [  getNumWorkers(building.id) | number:0  ]
            , a ng-click="city.removeWorker(building.id)">
              , icon-remove-worker></icon-remove-worker>
            ]
          ]
          , td [ class "description" ]>[  building.description  ]]
          , td [ class "actions" ]>
            , a [ class "btn btn-primary btn-buy" ] ng-click="purchase(building.id)"
              ng-[ class "canPurchase(building.id) || 'disabled'" ]>
              Buy [  getBuildingCost(building.id) | roundUp | number:0  ], iconMoney
            ]
          ]
        ]
      ]
    ]
  ] -}

module View.Empire where

import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Fixed exposing (..)
import Icons exposing (..)
import Model.City as City exposing (City)
import Model.Empire as Empire exposing (Empire)
import Update.Empire exposing (Action(..), Model(..), View(..))
import View.City exposing (cityDetail)

empireDetail : Signal.Address Action -> Model -> Html
empireDetail address model =
  let (Model _ empire) = model
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
mainView address (Model view empire) =
  div [ id "main" ]
    [ case view of
        CityList        -> cityListView address empire.cities
        CityDetails idx ->
          case List.head <| List.drop idx empire.cities of
            Just city -> cityDetailsView address empire.cities idx city
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

cityDetailsView : Signal.Address Action -> List City -> Int -> City -> Html
cityDetailsView address cities cityIndex city =
  div []
    [ h2 [] [ text "Cities" ]
    , div [ class "row" ]
      [ cityList address cities
      , cityDetail (Signal.forwardTo address (CityAction cityIndex)) city
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
    , td [ class "buildings" ] [ text << toString <| City.totalBuildings city ]
    , td [ class "money-delta" ] [ text << asFixed 2 <| city.moneyPerSecond ]
    , td [ class "exploration-delta" ] [ text << asFixed 2 <| city.explorationPerSecond ]
    , td [ class "unemployed" ] [ text << toString <| City.numUnemployed city ]
    ]

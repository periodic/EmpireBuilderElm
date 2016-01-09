module Update.Empire where

import Debug exposing (crash)
import Dict exposing (Dict)
import List
import Random
import Time exposing (Time)

import Data.Building
import Data.Constants as Constants
import Model.City
import Model.Empire exposing (Empire, defaultEmpire)
import Update.City
import WithRandom exposing (WithRandom)

type View = CityList
          | CityDetails Int
          | Upgrades
          | Achievements
          | Settings

type Model = Model View Empire

type Action
  = ShowCityList
  | ShowCityDetails Int
  | Tick Time
  | CityAction Int Update.City.Action

update : Action -> Model -> Model
update action (Model view empire) =
  case action of
    ShowCityList ->
      let view' = Debug.watch "View" (CityList)
      in Model view' empire

    ShowCityDetails index ->
      if index < (List.length <| .cities <| empire)
         then let view' = Debug.watch "View" (CityDetails index)
              in Model view' empire
         else always (Model CityList empire) <| Debug.log "Invalid city index in update." index

    Tick delta ->
      let cities' = List.map (Update.City.update (Update.City.Tick delta)) empire.cities
          empire' = Debug.watch "Empire" <| onTick delta { empire | cities = cities' }
      in Model view empire'

    CityAction index cityAction ->
      case cityAction of
        Update.City.Build buildingId ->
          let mCity = List.head <| List.drop index empire.cities
              mBuilding = Dict.get buildingId Data.Building.byId
          in case Maybe.map2  (,) mCity mBuilding of
            Just (city, building) ->
              let cost = Model.City.buildingCostNext city building
              in
                 if toFloat cost <= empire.money
                    then
                      let money' = empire.money - toFloat cost
                          empire' = Debug.watch "Empire" <| updateDynamicProperties
                            <| runCityAction index cityAction { empire | money = money' }
                      in Model view empire'
                    else always (Model view empire) <| Debug.log "Insufficient funds." cost
            Nothing ->
              always (Model view empire)
                <| Debug.log "Couldn't find city or building." (index, buildingId)
        action -> Model view <| updateDynamicProperties <| runCityAction index action empire


runCityAction : Int -> Update.City.Action -> Empire -> Empire
runCityAction index cityAction empire =
      let
          updateCity i city =
            if i == index
               then Update.City.update cityAction city
               else city
          cities' = List.indexedMap updateCity empire.cities
      in
         { empire | cities = cities' }



initializeWithSeed : WithRandom Model
initializeWithSeed =
  Update.City.buildCity Update.City.makeCapitolSite `WithRandom.andThen` \capitol ->
    WithRandom.return
    <| Model CityList
    <| updateDynamicProperties
      { defaultEmpire
      | cities = [capitol]
      , money = Constants.initialMoney
      }


updateDynamicProperties : Empire -> Empire
updateDynamicProperties empire =
  let moneyPerSecond = List.sum <| List.map .moneyPerSecond empire.cities
      explorationPerSecond = List.sum <| List.map .explorationPerSecond <| empire.cities
  in { empire | moneyPerSecond = moneyPerSecond, explorationPerSecond = explorationPerSecond }


updateEmpireForDelta : Float -> Empire -> Empire
updateEmpireForDelta multiplier empire =
  let money' = empire.money + empire.moneyPerSecond * multiplier
      exploration' = empire.exploration + empire.explorationPerSecond * multiplier
  in { empire | money = money', exploration = exploration' }


onTick : Time -> Empire -> Empire
onTick delta =
  updateEmpireForDelta (Time.inSeconds delta)


module Update.Empire where

import Debug exposing (crash)
import Dict exposing (Dict)
import List
import Random
import Time exposing (Time)

import Data.Constants as Constants
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
    Tick delta ->
      let cities' = List.map (Update.City.update (Update.City.Tick delta)) empire.cities
          empire' = onTick delta { empire | cities = cities' }
      in Model view empire'

    ShowCityList ->
      Model CityList empire

    ShowCityDetails index ->
      if index < (List.length <| .cities <| empire)
         then Model (CityDetails index) empire
         else Debug.log "Invalid city index in update." <| Model CityList empire

    CityAction index cityAction ->
      let
          updateCity i city =
            if i == index
               then Update.City.update cityAction city
               else city
          cities' = List.indexedMap updateCity empire.cities
      in
         Model view { empire | cities = cities' }



initializeWithSeed : WithRandom Model
initializeWithSeed =
  Update.City.buildCity Update.City.makeCapitolSite `WithRandom.andThen` \capitol ->
    WithRandom.return
    <| Model CityList
    <| updateEmpireDynamicProperties { defaultEmpire | cities = [capitol] }


updateEmpireDynamicProperties : Empire -> Empire
updateEmpireDynamicProperties empire =
  let moneyPerSecond = List.sum <| List.map .moneyPerSecond empire.cities
      explorationPerSecond = List.sum <| List.map .moneyPerSecond <| empire.cities
  in { empire | moneyPerSecond = moneyPerSecond, explorationPerSecond = explorationPerSecond }


updateEmpireForDelta : Float -> Empire -> Empire
updateEmpireForDelta multiplier empire =
  let money' = empire.money + empire.moneyPerSecond * multiplier
      exploration' = empire.exploration + empire.explorationPerSecond * multiplier
  in { empire | money = money', exploration = exploration' }


onTick : Time -> Empire -> Empire
onTick delta =
  updateEmpireForDelta (Time.inSeconds delta)


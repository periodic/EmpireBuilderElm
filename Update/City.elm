module Update.City where

import Debug
import Dict exposing (Dict)
import Random
import Time exposing (Time)

import Data.Building as Building
import Data.Constants as Constants
import Data.City as City
import Model.City exposing (..)
import WithRandom exposing (WithRandom)

type Action
  = Build BuildingId
  | Tick Time


update : Action -> City -> City
update action city =
  case action of
    Build buildingId ->
      Debug.crash "Unimplemented"

    Tick delta ->
      updateCityForDelta (Time.inSeconds delta) city


updateWithDefault :
  number
  -> (number -> number)
  -> comparable
  -> Dict comparable number
  -> Dict comparable number
updateWithDefault default f key dict =
  Dict.update key (\mCount ->
    case mCount of
      Nothing -> Just default
      Just val -> Just (f val))
    dict


incrementDict : comparable -> Dict comparable number -> Dict comparable number
incrementDict = updateWithDefault 1 (\x -> x + 1)

addBuilding : BuildingId -> City -> City
addBuilding buildingId city =
  { city | buildings = incrementDict buildingId city.buildings }

sumOverBuildings : (Building -> Float) -> Dict BuildingId Int -> Float
sumOverBuildings f buildings = Dict.foldl (\buildingId count acc ->
      case Dict.get buildingId Building.byId of
        Just building -> f building * toFloat count + acc
        Nothing       -> acc) 0 buildings

updateDynamicProperties : City -> City
updateDynamicProperties city =
  let buildingMPS = sumOverBuildings .moneyPerSecond city.buildings
                  + sumOverBuildings .moneyPerSecondWorked city.workers
      buildingFPS = sumOverBuildings .foodPerSecond city.buildings
                  + sumOverBuildings .foodPerSecond city.workers
      buildingEPS = sumOverBuildings .explorationPerSecond city.buildings
                  + sumOverBuildings .explorationPerSecond city.workers
      mps = (city.site.moneyBonus + buildingMPS) * city.site.moneyMultiplier
      fps = (city.site.foodBonus + buildingFPS) * city.site.foodMultiplier
      eps = (city.site.explorationBonus + buildingEPS) * city.site.explorationMultiplier
  in { city | moneyPerSecond = mps, explorationPerSecond = eps, foodPerSecond = fps }


updateCityForDelta : Float -> City -> City
updateCityForDelta multiplier city =
  let food' = city.food + city.foodPerSecond * multiplier
      foodRequired = nextBirth city
  in if food' >= foodRequired
        then { city | food = food' - foodRequired, population = city.population + 1 }
        else { city | food = food' }


sumOverModifiers : (CityModifier -> Float) -> Dict CityModifierId Float -> Float
sumOverModifiers f modifiers =
  Dict.foldl (\modifierId strength acc ->
    case Dict.get modifierId City.modifiersById of
      Just modifier -> f modifier * strength + acc
      Nothing       -> acc) 0 modifiers


makeSite : Float -> Dict CityModifierId Float -> Site
makeSite distance modifiers =
  let costMultiplier = distance / Constants.baseDistance + 1
      moneyMultiplier = 1 + sumOverModifiers .moneyMultiplier modifiers
      foodMultiplier = 1 + sumOverModifiers .foodMultiplier modifiers
      explorationMultiplier = 1 + sumOverModifiers .explorationMultiplier modifiers
      moneyBonus = sumOverModifiers .moneyBonus modifiers
      foodBonus = sumOverModifiers .foodBonus modifiers
      explorationBonus = sumOverModifiers .explorationBonus modifiers
  in { distance = distance
     , modifiers = modifiers
     , costMultiplier = costMultiplier
     , moneyMultiplier = moneyMultiplier
     , explorationMultiplier = explorationMultiplier
     , foodMultiplier = foodMultiplier
     , moneyBonus = moneyBonus
     , explorationBonus = explorationBonus
     , foodBonus = foodBonus
     }


makeCapitolSite : Site
makeCapitolSite = makeSite 0 <| Dict.fromList [("capitol-base", 1)]


buildCity : Site -> WithRandom City
buildCity site =
  let maxIndex = List.length City.names - 1
  in WithRandom.getRandom (Random.int 0 maxIndex) `WithRandom.andThen` \nameIndex ->
    let mName = List.head <| List.drop nameIndex City.names
        name = case mName of
          Just nameData ->
            nameData.name

          Nothing       ->
            Debug.crash <| "Could not get city name for index " ++ toString nameIndex
    in WithRandom.return <| updateDynamicProperties { defaultCity | name = name, site = site }


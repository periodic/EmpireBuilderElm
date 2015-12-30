module Game where

import Debug exposing (crash)
import Dict
import List
import Random
import Time exposing (Time)

import Achievement
import Building
import City
import Constants
import Empire exposing (City, Empire, Site)

type alias GameState =
  { empire : Empire
  , seed : Random.Seed
  }

type alias Game a = GameState -> (a, GameState)

(->>) : Game a -> Game b -> Game b
(->>) ma mb = \state ->
  let (_, state') = ma state
  in mb state'
infixl 1 ->>

(|>>) : Game a -> (a -> Game b) -> Game b
(|>>) ma mf = \state ->
  let (a, state') = ma state
  in mf a state'
infixl 1 |>>

return : a -> Game a
return a = \state -> (a, state)

get : Game GameState
get = \state -> (state, state)

put : GameState -> Game ()
put state' = \state -> ((), state')

modify : (GameState -> GameState) -> Game ()
modify f = \state -> ((), f state)

getRandom : Random.Generator a -> Game a
getRandom gen =
  get |>> \state ->
    let (a, seed') = Random.generate gen state.seed
    in put {state | seed = seed'} ->> return a

runGame : GameState -> Game a -> (a, GameState)
runGame state ma = ma state

evalGame : GameState -> Game a -> a
evalGame state ma = fst <| ma state

execGame : GameState -> Game a -> GameState
execGame state ma = snd <| ma state

initialState : Random.Seed -> GameState
initialState seed =
  let state = { empire = Empire.default
              , seed = seed
              }
  in execGame state initializeEmpire

makeCapitolSite : Site
makeCapitolSite = City.makeSite 0 <| Dict.fromList [("capitol-base", 1)]

initializeEmpire : Game ()
initializeEmpire =
  let defaultEmpire = Empire.default
  in buildCity makeCapitolSite |>> \capitol ->
    let empire = updateEmpireDynamicProperties { defaultEmpire | cities = [capitol] }
    in modify (\state -> { state | empire = empire })

updateEmpireDynamicProperties : Empire -> Empire
updateEmpireDynamicProperties empire =
  let moneyPerSecond = List.sum <| List.map .moneyPerSecond empire.cities
      explorationPerSecond = List.sum <| List.map .moneyPerSecond empire.cities
  in { empire | moneyPerSecond = moneyPerSecond, explorationPerSecond = explorationPerSecond }

buildCity : Site -> Game City
buildCity site =
  let maxIndex = List.length City.names - 1
  in getRandom (Random.int 0 maxIndex) |>> \nameIndex ->
    let mName = List.head <| List.drop nameIndex City.names
        name = case mName of
          Just nameData -> nameData.name
          Nothing       -> crash <| "Could not get city name for index " ++ toString nameIndex
        defaultCity = City.default
    in return <| City.updateDynamicProperties { defaultCity | name = name, site = site }

updateEmpireForDelta : Float -> Empire -> Empire
updateEmpireForDelta multiplier empire =
  let money' = empire.money + empire.moneyPerSecond * multiplier
      exploration' = empire.exploration + empire.explorationPerSecond * multiplier
      cities' = List.map (City.updateCityForDelta multiplier) empire.cities
  in { empire | money = money', exploration = exploration', cities = cities' }

onTick : Time -> Game ()
onTick delta =
  get |>> \state ->
        let multiplier = Time.inSeconds delta
        in put <| { state | empire = updateEmpireForDelta multiplier state.empire }


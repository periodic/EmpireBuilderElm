module Game where

import Debug exposing (crash)
import Dict exposing (Dict)
import List
import Random
import Time exposing (Time)

import Achievement
import Update.City
import Data.Constants as Constants
import Data.Building as Building
import Data.City as City
-- TODO(periodic): Change this to all functions from Update.City.
import Model.City exposing (City, CityModifier, CityModifierId, Site, defaultCity)
import Empire exposing (Empire, defaultEmpire)

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
  let state = { empire = defaultEmpire
              , seed = seed
              }
  in execGame state initializeEmpire

initializeEmpire : Game ()
initializeEmpire =
  buildCity makeCapitolSite |>> \capitol ->
    let empire = updateEmpireDynamicProperties { defaultEmpire | cities = [capitol] }
    in modify (\state -> { state | empire = empire })

updateEmpireDynamicProperties : Empire -> Empire
updateEmpireDynamicProperties empire =
  let moneyPerSecond = List.sum <| List.map .moneyPerSecond empire.cities
      explorationPerSecond = List.sum <| List.map .moneyPerSecond <| empire.cities
  in { empire | moneyPerSecond = moneyPerSecond, explorationPerSecond = explorationPerSecond }

updateEmpireForDelta : Float -> Empire -> Empire
updateEmpireForDelta multiplier empire =
  let money' = empire.money + empire.moneyPerSecond * multiplier
      exploration' = empire.exploration + empire.explorationPerSecond * multiplier
      cities' = List.map (Update.City.updateCityForDelta multiplier) empire.cities
  in { empire | money = money', exploration = exploration', cities = cities' }

onTick : Time -> Game ()
onTick delta =
  get |>> \state ->
        let multiplier = Time.inSeconds delta
        in put <| { state | empire = updateEmpireForDelta multiplier state.empire }


module Model where

import Random

import Empire exposing (Empire, City)
import Game exposing (..)

type View = CityList
          | CityDetails Int
          | Upgrades
          | Achievements
          | Settings

type Model = Model View GameState

start : Random.Seed -> Model
start seed =
  let gameState = Game.initialState seed
      cities = gameState.empire.cities
  in Model CityList gameState

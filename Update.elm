module Update where

import Debug
import Html exposing (..)
import List
import Time exposing (Time)

import Game
import Model exposing (Model(..), View(..))

type Action
  = ShowCityList
  | ShowCityDetails Int
  | Tick Time

update : Action -> Model -> Model
update action (Model view gameState) =
  case action of
    Tick t ->
      Model view <| Debug.watch "GameState" <| Game.execGame gameState (Game.onTick t)

    ShowCityList ->
      Model CityList gameState

    ShowCityDetails index ->
      if index < (List.length << .cities <| gameState.empire)
         then Model (CityDetails index) gameState
         else Debug.log "Invalid city index in update." <| Model CityList gameState

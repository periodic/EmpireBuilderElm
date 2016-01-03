module Main where

import Debug
import Maybe
import Random
import Signal
import StartApp.Simple as StartApp
import Time exposing (Time, timestamp)

import Model.City
import Update.City
import View.City
import WithRandom

type alias Model = Model.City.City

main = 
  let startWithSeed = WithRandom.evalWithRandom (Update.City.buildCity Update.City.makeCapitolSite)
      view = View.City.cityDetail
      update = Update.City.update

      startTime : Signal Time
      startTime = Signal.constant () |> timestamp |> Signal.map fst
      seedSignal : Signal Random.Seed
      seedSignal = Signal.map (Time.inMilliseconds >> round >> Random.initialSeed) startTime


      actions = Signal.mailbox Nothing
      address = Signal.forwardTo actions.address Just

      fpsSignal = Signal.map (Just << Update.City.Tick) <| Time.fps 10

      actionsSignal = Signal.mergeMany 
          [ actions.signal
          , fpsSignal
          ]

      inputSignal = Signal.map2 (,) seedSignal actionsSignal

      updateWithInit (seed, appSignal) mModel =
        let model =
          case mModel of
            Just model ->
              model
            Nothing ->
              startWithSeed seed
        in case appSignal of
          Just action ->
            Just <| update action model
          Nothing ->
            Just model

      mModelSignal : Signal (Maybe Model)
      mModelSignal = Signal.foldp updateWithInit Nothing inputSignal

      modelSignal : Signal Model
      modelSignal = 
        mModelSignal
        |> Signal.filter
            (\mModel ->
              case mModel of
                Just model -> True
                Nothing -> False)
            (Just <| startWithSeed <| Random.initialSeed 0)
        |> Signal.map (\mModel ->
          case mModel of
            Just model -> model
            Nothing -> Debug.crash "Got outgoing empty model")
  in Signal.map (view address) modelSignal

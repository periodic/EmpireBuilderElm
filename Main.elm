module Main where

import Debug
import Maybe
import Random
import Signal
import StartApp.Simple as StartApp
import Time exposing (Time, timestamp)

import Model exposing (Model)
import Update
import View
main = 
  let startTime : Signal Time
      startTime = Signal.constant () |> timestamp |> Signal.map fst
      seedSignal : Signal Random.Seed
      seedSignal = Signal.map (Time.inMilliseconds >> round >> Random.initialSeed) startTime

      initialModelSignal : Signal Model
      initialModelSignal = Signal.map Model.start seedSignal

      actions = Signal.mailbox Nothing
      address = Signal.forwardTo actions.address Just

      fpsSignal = Signal.map (Just << Update.Tick) <| Time.fps 10

      actionsSignal = Signal.mergeMany 
          [ actions.signal
          , fpsSignal
          ]

      inputSignal = Signal.map2 (,) seedSignal actionsSignal

      update (seed, appSignal) mModel =
        let model =
          case mModel of
            Just model -> model
            Nothing -> Model.start seed
        in case appSignal of
          Just action -> Just <| Update.update action model
          Nothing -> Just model

      mModelSignal : Signal (Maybe Model)
      mModelSignal = Signal.foldp update Nothing inputSignal

      modelSignal : Signal Model
      modelSignal = 
        mModelSignal
        |> Signal.filter
            (\mModel ->
              case mModel of
                Just model -> True
                Nothing -> False)
            (Just <| Model.start <| Random.initialSeed 0)
        |> Signal.map (\mModel ->
          case mModel of
            Just model -> model
            Nothing -> Debug.crash "Got outgoing empty model")
  in Signal.map (View.view address) modelSignal

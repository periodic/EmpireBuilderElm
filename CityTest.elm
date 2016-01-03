module CityTest where

import Dict
import Maybe

import Test exposing ((?))

import City
import Empire

allTests = 
  [ { name = "addBuildingMultiple"
    , result = 
      let
          city = City.addBuilding "foo" <| City.addBuilding "foo" defaultCity
          initialFoo = Maybe.withDefault 0 <| Dict.get "foo" <| .buildings defaultCity
          finalFoo = Maybe.withDefault 0 <| Dict.get "foo" city.buildings
      in
         finalFoo == initialFoo + 2 ? "Expected two additional 'foo' buildings in " ++ toString city
    }
  ]

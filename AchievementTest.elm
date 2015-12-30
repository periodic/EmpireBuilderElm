module AchievementTest where

import Test exposing ((?))

import Achievement exposing (..)
import City exposing (..)
import Empire exposing (..)

allTests =
  [ { name = "numCitiesEmpty"
    , result = Achievement.numCities Empire.default == 0 ? "Expected no cities in " ++ toString Empire.default
    }
  , { name = "numCitiesSingle"
    , result =
      let
          defaultEmpire = Empire.default
          empire = { defaultEmpire | cities = [City.default] }
      in
         Achievement.numCities empire == 1 ? "Expected one city in " ++ toString empire
    }
  , { name = "numCitiesMultiple"
    , result =
      let
          defaultEmpire = Empire.default
          empire = { defaultEmpire | cities = [City.default, City.default] }
      in
         Achievement.numCities empire == 2 ? "Expected two city in " ++ toString empire
    }
  , { name = "numBuildingsMultipleInSingleCity"
    , result =
      let
          city = City.addBuilding "foo" <| City.addBuilding "foo" City.default
          defaultEmpire = Empire.default
          empire = { defaultEmpire | cities = [city] }
      in
         Achievement.numBuildings ["foo"] empire == 2
           ? "Expected two buildings 'foo' in " ++ toString empire
    }
  , { name = "numBuildingsMultipleAcrossMultipleCities"
    , result =
      let
          city1 = City.addBuilding "foo" City.default
          city2 = City.addBuilding "foo" <| City.addBuilding "foo" City.default
          defaultEmpire = Empire.default
          empire = { defaultEmpire | cities = [city1, city2] }
      in
         Achievement.numBuildings ["foo"] empire == 3
           ? "Expected two buildings 'foo' in " ++ toString empire
    }
  ]


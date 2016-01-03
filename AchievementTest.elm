module AchievementTest where

import Test exposing ((?))

import Achievement exposing (..)
import City exposing (..)
import Empire exposing (..)

allTests =
  [ { name = "numCitiesEmpty"
    , result = Achievement.numCities defaultEmpire == 0 ? "Expected no cities in " ++ toString defaultEmpire
    }
  , { name = "numCitiesSingle"
    , result =
      let
          defaultEmpire = defaultEmpire
          empire = { defaultEmpire | cities = [defaultCity] }
      in
         Achievement.numCities empire == 1 ? "Expected one city in " ++ toString empire
    }
  , { name = "numCitiesMultiple"
    , result =
      let
          defaultEmpire = defaultEmpire
          empire = { defaultEmpire | cities = [defaultCity, defaultCity] }
      in
         Achievement.numCities empire == 2 ? "Expected two city in " ++ toString empire
    }
  , { name = "numBuildingsMultipleInSingleCity"
    , result =
      let
          city = City.addBuilding "foo" <| City.addBuilding "foo" defaultCity
          defaultEmpire = defaultEmpire
          empire = { defaultEmpire | cities = [city] }
      in
         Achievement.numBuildings ["foo"] empire == 2
           ? "Expected two buildings 'foo' in " ++ toString empire
    }
  , { name = "numBuildingsMultipleAcrossMultipleCities"
    , result =
      let
          city1 = City.addBuilding "foo" defaultCity
          city2 = City.addBuilding "foo" <| City.addBuilding "foo" defaultCity
          defaultEmpire = defaultEmpire
          empire = { defaultEmpire | cities = [city1, city2] }
      in
         Achievement.numBuildings ["foo"] empire == 3
           ? "Expected two buildings 'foo' in " ++ toString empire
    }
  ]


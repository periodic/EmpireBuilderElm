module Model.City where

import Dict exposing (Dict)

import Data.Constants as Constants

type alias BuildingId = String
type alias Building =
  { id : BuildingId
  , name : String
  , description : String
  , cost : Float
  , moneyPerSecond : Float
  , moneyPerSecondWorked : Float
  , foodPerSecond : Float
  , foodPerSecondWorked : Float
  , explorationPerSecond : Float
  , explorationPerSecondWorked : Float
  }

type alias CityModifierId = String
type alias CityModifier =
  { id : CityModifierId
  , name : String
  , moneyMultiplier : Float       -- Money multiplier, zero based.
  , moneyBonus: Float             -- money / second
  , explorationMultiplier: Float  -- Exploration multipler, zero based.
  , explorationBonus: Float       -- exploration / second
  , foodMultiplier: Float         -- Food multiplier, zero based.
  , foodBonus: Float              -- food / second
  }

type alias Site =
  { distance : Float
  , modifiers : Dict CityModifierId Float
  -- Dynamic properties
  , costMultiplier : Float
  , moneyMultiplier : Float
  , explorationMultiplier : Float
  , foodMultiplier : Float
  , moneyBonus : Float
  , explorationBonus : Float
  , foodBonus : Float
  }

type alias City =
  { name : String
  , buildings : Dict BuildingId Int
  , workers : Dict BuildingId Int
  , site : Site
  -- Dynamic properties
  , food : Float
  , population : Int
  , moneyPerSecond : Float
  , explorationPerSecond : Float
  , foodPerSecond : Float
  }

defaultModifier : CityModifier
defaultModifier =
  { id = "default"
  , name = "Default"
  , moneyMultiplier = 0
  , moneyBonus = 0
  , explorationMultiplier = 0
  , explorationBonus = 0
  , foodMultiplier = 0
  , foodBonus = 0
  }


defaultSite : Site
defaultSite =
  { distance = 0
  , modifiers = Dict.empty
  , costMultiplier = 1.0
  , moneyMultiplier = 1.0
  , explorationMultiplier = 1.0
  , foodMultiplier = 1.0
  , moneyBonus = 0.0
  , explorationBonus = 0.0
  , foodBonus = 0.0
  }

defaultCity : City
defaultCity =
  { name = "Unnamed"
  , buildings = Dict.empty
  , workers = Dict.empty
  , site = defaultSite
  , food = 0
  , population = 1
  , moneyPerSecond = 0
  , explorationPerSecond = 0
  , foodPerSecond = 0
  }

isCapitol : City -> Bool
isCapitol city =
  Dict.member "capitol" city.site.modifiers

numBuildings : City -> Int
numBuildings city =
  Dict.foldl (\_ v acc -> acc + v) 0 city.buildings

numWorking : City -> Int
numWorking city =
  Dict.foldl (\_ v acc -> acc + v) 0 city.workers

numUnemployed : City -> Int
numUnemployed city =
  city.population - numWorking city

nextBirth : City -> Float
nextBirth city =
  Constants.baseFoodRequirement * .foodCost Constants.growthFactors ^ toFloat (city.population - 1)


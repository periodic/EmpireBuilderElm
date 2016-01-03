module Model.Empire where

import List
import Dict exposing (Dict)
import Model.City exposing (City, Site)


type alias AchievementId = String
type alias Achievement =
  { id : AchievementId
  , name : String
  , description : String
  , points : Int
  , metric : Empire -> Int
  , goal : Int
  }
type AchievementList = AchievementList (List Achievement)


type alias UpgradeId = String
type alias Upgrade = {}


type alias Empire =
  { achievementsAvailable : AchievementList
  , achievementsAcquired : AchievementList
  , achievementScore : Int
  , cities : List City
  , sites : List Site
  , upgradesPurchased : Dict UpgradeId Int
  -- Resources
  , money : Float
  , exploration : Float
  -- Derived rates
  , moneyPerSecond : Float
  , explorationPerSecond : Float
  , globalMoneyMultiplier : Float
  , globalExplorationMultiplier : Float
  , globalFoodMultiplier : Float
  }

defaultEmpire =
  { achievementsAcquired = AchievementList []
  , achievementsAvailable = AchievementList []
  , achievementScore = 0
  , cities = []
  , sites = []
  , upgradesPurchased = Dict.empty
  , money = 0
  , exploration = 0
  , moneyPerSecond = 0
  , explorationPerSecond = 0
  , globalMoneyMultiplier = 1.0
  , globalExplorationMultiplier = 1.0
  , globalFoodMultiplier = 1.0
  }


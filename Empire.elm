module Empire where

import List
import Dict exposing (Dict)

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

default =
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


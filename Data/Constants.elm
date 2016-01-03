module Data.Constants where

updateDelay = 100 -- ms
saveDelay = 1000 -- ms

baseCityCost = 1000
baseFoodRequirement = 100
baseDistance = 100

initialMoney = 100
initialExploration = 0

distanceFudgeFactor = 0.1

baseModifierChance = 0.5
baseModifierStrength = 0.10

baseExplorationCost = 100
baseExplorationDistance = 20

growthFactors =
  { buildingCost = 1.5
  , cityCost = 4.0
  , explorationCost = 1.3
  , foodCost = 1.5
  , upgrade = 2.0
  , explorationDistance = 1.2
  }

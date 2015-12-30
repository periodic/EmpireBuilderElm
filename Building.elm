module Building where

import Dict exposing (Dict)

import Empire exposing (Building, BuildingId)

grow : Float -> Float -> Float -> Float
grow base growthFactor n = base * growthFactor ^ n

-- Exploration buildings.
-- Cost Growth: x5
-- Production Growth: x2
expCostBase = 100
expCostGrowth = 5.0
expProductionBase = 0.1
expProductionGrowth = 1.5
expWorkedBase = 0.25
expWorkedGrowth = 2.0

-- Food buildings
-- Cost Growth: x5
-- Production Growth: x3
foodCostBase = 50
foodCostGrowth = 5.0
foodProductionBase = 0.1
foodProductionGrowth = 3.0
foodWorkedBase = 1.0
foodWorkedGrowth = 3.0

-- Money buildings
-- Cost Growth: x5
-- Production Growth: x4
moneyCostBase = 75
moneyCostGrowth = 5.0
moneyProductionBase = 0.1
moneyProductionGrowth = 4.0
moneyWorkedBase = 1.0
moneyWorkedGrowth = 4.0

buildings =
  [ -- Exploration Buildings
    { id = "explore1"
    , name = "Outfitter"
    , description = "Outfits expeditions that are venturing out to explore the world."
    , cost = grow expCostBase expCostGrowth 0
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = grow expProductionBase expProductionGrowth 0
    , explorationPerSecondWorked = grow expWorkedBase expWorkedGrowth 0
    }
  , { id = "explore2"
    , name = "Explorer's Guild"
    , description = "They go out and find stuff."
    , cost = grow expCostBase expCostGrowth 1
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = grow expProductionBase expProductionGrowth 1
    , explorationPerSecondWorked = grow expWorkedBase expWorkedGrowth 1
    }
  , { id = "explore3"
    , name = "Explorer's Guild 2"
    , description = "They go out and find stuff."
    , cost = grow expCostBase expCostGrowth 2
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = grow expProductionBase expProductionGrowth 2
    , explorationPerSecondWorked = grow expWorkedBase expWorkedGrowth 2
    }
  , { id = "explore4"
    , name = "Explorer's Guild 3"
    , description = "They go out and find stuff."
    , cost = grow expCostBase expCostGrowth 3
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = grow expProductionBase expProductionGrowth 3
    , explorationPerSecondWorked = grow expWorkedBase expWorkedGrowth 3
    }
  , { id = "explore5"
    , name = "Explorer's Guild 4"
    , description = "They go out and find stuff."
    , cost = grow expCostBase expCostGrowth 4
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = grow expProductionBase expProductionGrowth 4
    , explorationPerSecondWorked = grow expWorkedBase expWorkedGrowth 4
    }

    -- Food Buildings
  , { id = "food1"
    , name = "Pasture"
    , description = "Has goats, chickens, and a variety of crops."
    , cost = grow foodCostBase foodCostGrowth 0
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    , foodPerSecond = grow foodProductionBase foodProductionGrowth 0
    , foodPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 0
    }
  , { id = "food2"
    , name = "Orchard"
    , description = "Has goats, chickens, and a variety of crops."
    , cost = grow foodCostBase foodCostGrowth 1
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    , foodPerSecond = grow foodProductionBase foodProductionGrowth 1
    , foodPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 1
    }
  , { id = "food3"
    , name = "Farm"
    , description = "Has goats, chickens, and a variety of crops."
    , cost = grow foodCostBase foodCostGrowth 2
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    , foodPerSecond = grow foodProductionBase foodProductionGrowth 2
    , foodPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 2
    }
  , { id = "food4"
    , name = "Irrigated Cropland"
    , description = "Has goats, chickens, and a variety of crops."
    , cost = grow foodCostBase foodCostGrowth 3
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    , foodPerSecond = grow foodProductionBase foodProductionGrowth 3
    , foodPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 3
    }
  , { id = "food5"
    , name = "Hydroponics"
    , description = "Has goats, chickens, and a variety of crops."
    , cost = grow foodCostBase foodCostGrowth 4
    , moneyPerSecond = 0
    , moneyPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    , foodPerSecond = grow foodProductionBase foodProductionGrowth 4
    , foodPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 4
    }

    -- Money buildings
  , { id = "money1"
    , name = "Workshop"
    , description = "A shop that has tools and machinery where things are made and fixed."
    , cost = grow moneyCostBase foodCostGrowth 0
    , moneyPerSecond = grow foodProductionBase foodProductionGrowth 0
    , moneyPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 0
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    }
  , { id = "money2"
    , name = "Market"
    , description = "A place for puchase and sale of provisions, livestock and other goods."
    , cost = grow moneyCostBase foodCostGrowth 1
    , moneyPerSecond = grow foodProductionBase foodProductionGrowth 1
    , moneyPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 1
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    }
  , { id = "money3"
    , name = "School"
    , description = "An instituion of learning."
    , cost = grow moneyCostBase foodCostGrowth 2
    , moneyPerSecond = grow foodProductionBase foodProductionGrowth 2
    , moneyPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 2
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    }
  , { id = "money5"
    , name = "Factory"
    , description = "A place for puchase and sale of provisions, livestock and other goods."
    , cost = grow moneyCostBase foodCostGrowth 3
    , moneyPerSecond = grow foodProductionBase foodProductionGrowth 3
    , moneyPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 3
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    }
  , { id = "money5"
    , name = "Bank"
    , description = "Show me the money."
    , cost = grow moneyCostBase foodCostGrowth 4
    , moneyPerSecond = grow foodProductionBase foodProductionGrowth 4
    , moneyPerSecondWorked = grow foodWorkedBase foodWorkedGrowth 4
    , foodPerSecond = 0
    , foodPerSecondWorked = 0
    , explorationPerSecond = 0
    , explorationPerSecondWorked = 0
    }
  ]

byId : Dict BuildingId Building
byId = Dict.fromList
     <| List.map (\building -> (building.id, building)) buildings

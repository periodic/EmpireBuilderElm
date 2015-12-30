module Achievement where

import Dict exposing (Dict)

import Empire exposing (Achievement, AchievementId, Empire)

foodBuildings = ["food1", "food2", "food3", "food4", "food5"]
exploreBuildings = ["explore1", "explore2", "explore3", "explore4", "explore5"]
moneyBuildings = ["money1", "money2", "money3", "money4", "money5"]

numBuildings : List String -> Empire -> Int
numBuildings buildingList empire =
  List.sum
  <| List.map
    (\city ->
      List.sum
      <| List.map (\buildingId -> case Dict.get buildingId city.buildings of
                      Nothing -> 0
                      Just count -> count)
                  buildingList)
    empire.cities

numCities : Empire -> Int
numCities {cities} = List.length cities

achievements : List Achievement
achievements =
  [ { id = "city1"
    , name = "It's a free country"
    , description = "Build 1 additional city."
    , points = 1
    , metric = numCities
    , goal = 2
    }
  , { id = "city2"
    , name = "Industrial strength"
    , description = "Have 5 cities."
    , points = 10
    , metric = numCities
    , goal = 5
    }
  , { id = "city3"
    , name = "Vim and vigour"
    , description = "Build 10 cities."
    , points = 20
    , metric = numCities
    , goal = 10
    }
  , { id = "city4"
    , name = "Larger than life"
    , description = "Build 50 cities."
    , points = 100
    , metric = numCities
    , goal = 50
    }
  , { id = "food1"
    , name = "Digging in"
    , description = "Build 5 food-production buildings."
    , points = 1
    , metric = numBuildings foodBuildings
    , goal = 5
    }
  , { id = "food2"
    , name = "Buying the farm"
    , description = "Build 20 food-production buildings."
    , points = 2
    , metric = numBuildings foodBuildings
    , goal = 50
    }
  , { id = "food3"
    , name = "The cream of the crop"
    , description = "Build 50 food-production buildings."
    , points = 5
    , metric = numBuildings foodBuildings
    , goal = 100
    }
  , { id = "food4"
    , name = "Covering a lot of ground"
    , description = "Build 100 food-production buildings."
    , points = 10
    , metric = numBuildings foodBuildings
    , goal = 500
    }
  , { id = "money1"
    , name = "Easy money"
    , description = "Build 5 money-production buildings."
    , points = 1
    , metric = numBuildings moneyBuildings
    , goal = 5
    }
  , { id = "money2"
    , name = "A consumers dozen"
    , description = "Build 12 money-production buildings."
    , points = 2
    , metric = numBuildings moneyBuildings
    , goal = 50
    }
  , { id = "money3"
    , name = "Go for broke"
    , description = "Build 50 money-production buildings."
    , points = 5
    , metric = numBuildings moneyBuildings
    , goal = 100
    }
  , { id = "money4"
    , name = "Breaking the bank"
    , description = "Build 100 money-production buildings."
    , points = 10
    , metric = numBuildings moneyBuildings
    , goal = 500
    }
  , { id = "explore1"
    , name = "Setting Out"
    , description = "Build 5 exploration buildings."
    , points = 1
    , metric = numBuildings exploreBuildings
    , goal = 5
    }
  , { id = "explore2"
    , name = "Over the Hill"
    , description = "Build 20 exploration buildings."
    , points = 2
    , metric = numBuildings exploreBuildings
    , goal = 50
    }
  , { id = "explore3"
    , name = "Across the Sea"
    , description = "Build 50 exploration buildings."
    , points = 5
    , metric = numBuildings exploreBuildings
    , goal = 100
    }
  , { id = "explore4"
    , name = "Mapping the World"
    , description = "Build 100 exploration buildings."
    , points = 10
    , metric = numBuildings exploreBuildings
    , goal = 500
    }
  ]

byId : Dict AchievementId Achievement
byId = Dict.fromList
     <| List.map (\achievement -> (achievement.id, achievement)) achievements

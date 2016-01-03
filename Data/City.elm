module Data.City where

import Dict exposing (Dict)

import City.Model exposing (CityModifierId, CityModifier, defaultModifier)

modifiers : List CityModifier
modifiers =
  [ { defaultModifier
    | id = "capitol-base"
    , name = "The Capitol"
    , moneyBonus = 1.0
    , explorationBonus = 1.0
    , foodBonus = 1.0
    }
  , { defaultModifier
    | id = "capitol-scaling"
    , name = "Empire Size Bonus"
    , moneyMultiplier = 0.01
    , explorationMultiplier = 0.01
    , foodMultiplier = 0.01
    }
  , { defaultModifier
    | id = "money"
    , name = "Money Bonus"
    , moneyMultiplier = 1.0
    }
  , { defaultModifier
    | id = "exploration"
    , name = "Exploration Bonus"
    , explorationMultiplier = 1.0
    }
  , { defaultModifier
    | id = "food"
    , name = "Food Bonus"
    , foodMultiplier = 1.0
    }
  ]

randomModifiers : List CityModifierId
randomModifiers =
  [ "money"
  , "exploration"
  , "food"
  ]

names =
  [ { name = "Tokyo", country = "Japan", rank = 1 }
  , { name = "Jakarta", country = "Indonesia", rank = 2 }
  , { name = "Seoul", country = "South", rank = 3 }
  , { name = "Delhi", country = "India", rank = 4 }
  , { name = "Shanghai", country = "China", rank = 5 }
  , { name = "Manila", country = "Philippines", rank = 6 }
  , { name = "Karachi", country = "Pakistan", rank = 7 }
  , { name = "New York", country = "USA", rank = 8 }
  , { name = "Sao Paulo", country = "Brazil", rank = 9 }
  , { name = "Mexico City", country = "Mexico", rank = 10 }
  , { name = "Cairo", country = "Egypt", rank = 11 }
  , { name = "Beijing", country = "China", rank = 12 }
  , { name = "Osaka", country = "Japan", rank = 13 }
  , { name = "Mumbai", country = "India", rank = 14 }
  , { name = "Guangzhou", country = "China", rank = 15 }
  , { name = "Moscow", country = "Russia", rank = 16 }
  , { name = "Los Angeles", country = "USA", rank = 17 }
  , { name = "Calcutta", country = "India", rank = 18 }
  , { name = "Dhaka", country = "Bangladesh", rank = 19 }
  , { name = "Buenos Aires", country = "Argentina", rank = 20 }
  , { name = "Istanbul", country = "Turkey", rank = 21 }
  , { name = "Rio de Janeiro", country = "Brazil", rank = 22 }
  , { name = "Shenzhen", country = "China", rank = 23 }
  , { name = "Lagos", country = "Nigeria", rank = 24 }
  , { name = "Paris", country = "France", rank = 25 }
  , { name = "Toronto", country = "Canada", rank = 51 }
  , { name = "Kuala Lumpur", country = "Malaysia", rank = 52 }
  , { name = "Santiago", country = "Chile", rank = 53 }
  , { name = "Dallas", country = "USA", rank = 54 }
  , { name = "San Francisco-San Jose", country = "USA", rank = 55 }
  , { name = "Quanzhou", country = "China", rank = 56 }
  , { name = "Miami", country = "USA", rank = 57 }
  , { name = "Shenyang", country = "China", rank = 58 }
  , { name = "Belo Horizonte", country = "Brazil", rank = 59 }
  , { name = "Philadelphia", country = "USA", rank = 60 }
  , { name = "Nanjing", country = "China", rank = 61 }
  , { name = "Madrid", country = "Spain", rank = 62 }
  , { name = "Houston", country = "USA", rank = 63 }
  , { name = "Xi'an-Xianyang", country = "China", rank = 64 }
  , { name = "Milan", country = "Italy", rank = 65 }
  , { name = "Luanda", country = "Angola", rank = 66 }
  , { name = "Pune", country = "India", rank = 67 }
  , { name = "Singapore", country = "Singapore", rank = 68 }
  , { name = "Riyadh", country = "Saudi", rank = 69 }
  , { name = "Khartoum", country = "Sudan", rank = 70 }
  , { name = "Saint Petersburg", country = "Russia", rank = 71 }
  , { name = "Atlanta", country = "USA", rank = 72 }
  , { name = "Surat", country = "India", rank = 73 }
  , { name = "Washington", country = "D", rank = 74 }
  , { name = "Bandung", country = "Indonesia", rank = 75 }
  , { name = "Nagoya", country = "Japan", rank = 26 }
  , { name = "Lima", country = "Peru", rank = 27 }
  , { name = "Chicago", country = "USA", rank = 28 }
  , { name = "Kinshasa", country = "Congo", rank = 29 }
  , { name = "Tianjin", country = "China", rank = 30 }
  , { name = "Chennai", country = "India", rank = 31 }
  , { name = "Bogota", country = "Colombia", rank = 32 }
  , { name = "Bengaluru", country = "India", rank = 33 }
  , { name = "London", country = "United Kingdom", rank = 34 }
  , { name = "Taipei", country = "Taiwan", rank = 35 }
  , { name = "Ho Chi Minh City", country = "Vietnam", rank = 36 }
  , { name = "Dongguan", country = "China", rank = 37 }
  , { name = "Hyderabad", country = "India", rank = 38 }
  , { name = "Chengdu", country = "China", rank = 39 }
  , { name = "Lahore", country = "Pakistan", rank = 40 }
  , { name = "Johannesburg", country = "South", rank = 41 }
  , { name = "Tehran", country = "Iran", rank = 42 }
  , { name = "Essen", country = "Germany", rank = 43 }
  , { name = "Bangkok", country = "Thailand", rank = 44 }
  , { name = "Hong Kong", country = "Hong", rank = 45 }
  , { name = "Wuhan", country = "China", rank = 46 }
  , { name = "Ahmedabad", country = "India", rank = 47 }
  , { name = "Chongqung", country = "China", rank = 48 }
  , { name = "Baghdad", country = "Iraq", rank = 49 }
  , { name = "Hangzhou", country = "China", rank = 50 }
  , { name = "Surabaya", country = "Indonesia", rank = 76 }
  , { name = "Yangoon", country = "Myanmar", rank = 77 }
  , { name = "Alexandria", country = "Egypt", rank = 78 }
  , { name = "Guadalajara", country = "Mexico", rank = 79 }
  , { name = "Harbin", country = "China", rank = 80 }
  , { name = "Boston", country = "USA", rank = 81 }
  , { name = "Zhengzhou", country = "China", rank = 82 }
  , { name = "Qingdao", country = "China", rank = 83 }
  , { name = "Abidjan", country = "Cote", rank = 84 }
  , { name = "Barcelona", country = "Spain", rank = 85 }
  , { name = "Monterrey", country = "Mexico", rank = 86 }
  , { name = "Ankara", country = "Turkey", rank = 87 }
  , { name = "Suzhou", country = "China", rank = 88 }
  , { name = "Phoenix", country = "USA", rank = 89 }
  , { name = "Salvador", country = "Brazil", rank = 90 }
  , { name = "Porto Alegre", country = "Brazil", rank = 91 }
  , { name = "Rome", country = "Italy", rank = 92 }
  , { name = "Accra", country = "Ghana", rank = 93 }
  , { name = "Sydney", country = "Australia", rank = 94 }
  , { name = "Recife", country = "Brazil", rank = 95 }
  , { name = "Naples", country = "Italy", rank = 96 }
  , { name = "Detroit", country = "USA", rank = 97 }
  , { name = "Dalian", country = "China", rank = 98 }
  , { name = "Fuzhou", country = "China", rank = 99 }
  , { name = "Medellin", country = "Colombia", rank = 100 }
  ]

modifiersById : Dict CityModifierId CityModifier
modifiersById = Dict.fromList
     <| List.map (\modifier -> (modifier.id, modifier)) modifiers

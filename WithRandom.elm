module WithRandom where

import Random

type alias WithRandom a = Random.Seed -> (a, Random.Seed)

andThen : WithRandom a -> (a -> WithRandom b) -> WithRandom b
andThen ma mf = \state ->
  let (a, state') = ma state
  in mf a state'

return : a -> WithRandom a
return a = \state -> (a, state)

get : WithRandom Random.Seed
get = \state -> (state, state)

put : Random.Seed -> WithRandom ()
put state' = \state -> ((), state')

getRandom : Random.Generator a -> WithRandom a
getRandom gen =
  \seed -> Random.generate gen seed

runWithRandom : WithRandom a -> Random.Seed -> (a, Random.Seed)
runWithRandom = (<|)

evalWithRandom : WithRandom a -> Random.Seed -> a
evalWithRandom rand seed = fst <| rand seed

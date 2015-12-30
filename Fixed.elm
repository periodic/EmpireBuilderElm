module Fixed where

import Debug

type Fixed = Fixed Int Int Int

toFixed : Int -> Float -> Fixed
toFixed n float =
  let base = 10
      multiplier = toFloat <| base ^ n
      digits = truncate (float * multiplier)
  in Fixed digits n base

renderFixed : Fixed -> String
renderFixed (Fixed d n b) =
  if n == 0
     then toString d
     else let multiplier = b ^ n
              whole = d // multiplier
              partial = d - (whole * multiplier)
          in toString whole ++ "." ++ toString partial

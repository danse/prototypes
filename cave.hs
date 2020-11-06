
{-
StringLike a => instance StringLike class Front a where
  toString (Front a) = "front " ++ toString a
-}

-- cave goal management
goals = [
  "work",
  "delivery",
  "train",
  "taxes",
  "atland",
  "papeles",
  "lungs",
  "culture",
  "abya yala",
  "time 30% mobile",
  "time 20% stand"
  ]

main = sequence (map putStrLn goals)

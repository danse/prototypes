{- kind of obsoleted by `tag` -}


{-# LANGUAGE OverloadedStrings #-}
{-
import System.Environment (getArgs)
import System.Directory (renamePath)


move dir file = renamePath file (dir ++ "/" ++ file)

group args =
  let dir = last args
      files = init args
  in do
    createDirectory dir
    sequence (map (move dir) files)

main = do
  args <- getArgs
  group args

-}
main = putStrLn "renamePath does not seem to be there?"

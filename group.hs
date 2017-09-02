{-# LANGUAGE OverloadedStrings #-}
import System.Environment (getArgs)
import System.Directory


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

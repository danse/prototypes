{-

mv arg /tmp/timestamped
mkdir arg
mv /tmp/timestamped arg

----

given a file, nests it into a directory with the same name

$ touch name
$ nest name
$ ls name/name
name/name


import System.Environment (getArgs)
import System.Directory (renamePath)
import System.IO.Temp (openTempFile, createTempDirectory)
import System.Directory (getTemporaryDirectory)

nest name = do
  -- create temporary directory
  -- move file to temporary dir
  -- move temporary dir to goal

main = do
  [arg] <- getArgs
  nest arg
-}

main = putStrLn "prototypes"

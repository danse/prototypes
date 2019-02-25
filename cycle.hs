{-# LANGUAGE NamedFieldPuns #-}
import Web.Browser (openBrowser)
import System.Environment (getArgs)
import Network.URI (isURI)
import Control.Monad (void)
import Prototypes (fileApply)
import Options.Applicative
import Data.Semigroup ((<>))

data Options = Options { fileNames :: [String], times :: Int }

options :: Parser Options
options = Options
          <$> some (argument str (metavar "FILES..."))
          <*> option auto
          (long "times"
           <> help "how many elements do you want to cycle?"
           <> showDefault
           <> value 1
           <> metavar "TIMES")

showOrBrowse s = if isURI s
                 then void (openBrowser s)
                 else print s

headOrError [] = "the file is empty"
headOrError o  = head o

shift []    = []
shift (h:t) = t ++ [h]

popAndShift :: String -> (String, String)
popAndShift contents = (unlines (shift l), headOrError l)
  where l = lines contents

cycle_ :: String -> Int -> IO ()
cycle_ fileName index = do
  popped <- fileApply fileName popAndShift
  showOrBrowse popped

-- every filename appears in a combination
combinations (Options { fileNames, times})
 | l < times = zip c [1..times]
 | otherwise = zip c [1..l]
 where l = length fileNames
       c = cycle fileNames

main = do
  user <- execParser (info (options <**> helper) fullDesc)
  sequence (map2 cycle_ (combinations user))
 where map2 :: (a -> b -> c) -> [(a,b)] -> [c]
       map2 f l = map (\ (a,b) -> f a b) l

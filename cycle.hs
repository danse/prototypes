{-# LANGUAGE NamedFieldPuns #-}
import Web.Browser (openBrowser)
import Network.URI (isURI)
import Control.Monad (void)
import Prototypes (fileApply)
import Options.Applicative
import Data.Semigroup ((<>))

data Options = Options {
  fileNames :: [String],
  times :: Int,
  plain :: Bool
  }

options :: Parser Options
options = Options
          <$> some (argument str (metavar "FILES..."))
          <*> option auto (long "times" <> help "how many elements do you want to cycle?" <> showDefault <> value 1 <> metavar "TIMES")
          <*> option auto (long "plain" <> help "print also web addresses rather than opening with a browser" <> showDefault <> value False)

headOrError [] = "the file is empty"
headOrError o  = head o

shift []    = []
shift (h:t) = t ++ [h]

popAndShift :: String -> (String, String)
popAndShift contents = (unlines (shift l), headOrError l)
  where l = lines contents

cycle_ :: Bool -> String -> Int -> IO ()
cycle_ plain fileName index = do
  popped <- fileApply fileName popAndShift
  if isURI popped && not plain then void (openBrowser popped)
    else putStrLn popped
  where withPref l = "https://" ++ l

combinations :: Options -> [(String, Int)]
-- every filename appears in a combination
combinations (Options { fileNames, times })
 | l < times = zip c [1..times]
 | otherwise = zip c [1..l]
 where l = length fileNames
       c = cycle fileNames

main = do
  opt <- execParser (info (options <**> helper) fullDesc)
  sequence (map2 (cycle_ (plain opt)) (combinations opt))
  where map2 :: (a -> b -> c) -> [(a,b)] -> [c]
        map2 f l = map (\ (a,b) -> f a b) l

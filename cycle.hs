{-# LANGUAGE RecordWildCards #-}
import Web.Browser (openBrowser)
import Network.URI (isURI)
import Control.Monad (void)
import Prototypes (fileApply)
import Options.Applicative
import Data.Semigroup ((<>))
import Data.Maybe (listToMaybe, fromMaybe)

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


popAndShift :: String -> (String, String)
popAndShift contents = (unlines (shift l), headOrError l)
  where
    l = lines contents
    shift []    = []
    shift (h:t) = t <> [h]
    headOrError = fromMaybe "the file is empty" . listToMaybe

-- | every filename appears in a combination
-- >>> cycleNames ["a", "b"] 5
-- ["a","b","a","b","a"]
cycleNames :: [String] -> Int -> [String]
cycleNames names times = take times $ cycle names

main = do
  Options{..} <- execParser (info (options <**> helper) fullDesc)
  sequence $ doCycle plain <$> cycleNames fileNames times
  where
    doCycle :: Bool -> String -> IO ()
    doCycle plain fileName = do
      popped <- fileApply fileName popAndShift
      if isURI popped && not plain then void (openBrowser popped)
        else putStrLn popped
      where withPref l = "https://" ++ l

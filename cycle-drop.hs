{-# LANGUAGE NamedFieldPuns #-}
import Web.Browser (openBrowser)
import System.Environment (getArgs)
import Network.URI (isURI)
import Control.Monad (void)
import Prototypes (fileApply)
import Options.Applicative
import Data.Semigroup ((<>))

data Options = Options {
  fileNames :: [String]
  }

options :: Parser Options
options = Options <$> some (argument str (metavar "FILES..."))

dropLast :: String -> (String, String)
dropLast contents = (unlines (init l), last l)
  where l = lines contents

drop' :: String -> IO ()
drop' fileName = do
  dropped <- fileApply fileName dropLast
  print dropped

main = do
  Options { fileNames } <- execParser (info (options <**> helper) fullDesc)
  sequence (map drop' fileNames)
  where map2 :: (a -> b -> c) -> [(a,b)] -> [c]
        map2 f l = map (\ (a,b) -> f a b) l

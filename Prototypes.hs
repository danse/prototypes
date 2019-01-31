module Prototypes where

import System.IO (
  openFile,
  hClose,
  hPutStr,
  hFlush,
  hClose,
  IOMode(..))
import qualified System.IO.Strict as Strict

pipeThrough :: (String -> String) -> IO ()
pipeThrough f = do
  contents <- getContents
  putStr (f contents)

pipeLinesThrough :: ([String] -> [String]) -> IO ()
pipeLinesThrough f = pipeThrough (unlines . f . lines)

fileApply :: FilePath -> (String -> (String, a)) -> IO a
fileApply fileName f = do
  readHandle <- openFile fileName ReadMode
  contents <- Strict.hGetContents readHandle
  hClose readHandle
  writeHandle <- openFile fileName WriteMode
  hPutStr writeHandle (fst $ f contents)
  hFlush writeHandle
  hClose writeHandle
  pure (snd $ f contents)


module Prototypes where

import System.IO
import qualified System.IO.Strict as Strict

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


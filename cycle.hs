import Web.Browser (openBrowser)
import System.Environment (getArgs)
import Network.URI (isURI)
import Control.Monad (void)
import System.IO
import qualified System.IO.Strict as Strict

showOrBrowse s = if isURI s
                 then void (openBrowser s)
                 else print s

headOrError [] = "the file is empty"
headOrError o  = head o

shift []    = []
shift (h:t) = t ++ [h]

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

popAndShift :: String -> (String, String)
popAndShift contents = (unlines (shift l), headOrError l)
  where l = lines contents

main = do
  [fileName] <- getArgs
  popped <- fileApply fileName popAndShift
  showOrBrowse popped

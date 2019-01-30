import Web.Browser (openBrowser)
import System.Environment (getArgs)
import Network.URI (isURI)
import Control.Monad (void)
import Prototypes (fileApply)

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

main = do
  [fileName] <- getArgs
  popped <- fileApply fileName popAndShift
  showOrBrowse popped

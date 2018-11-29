import Web.Browser (openBrowser)
import Control.Monad (void)
import Network.URI (isURI)
import System.IO

addProtocol s = if isURI s then s else "https://" <> s

main = do
  contents <- hGetContents stdin
  mapM (openBrowser . addProtocol) (words contents)

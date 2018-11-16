import Data.List
import System.Posix.Types
import qualified System.Posix.Files as Files
import System.FilePath.Find
import System.Environment
import Control.Monad
import Data.Ord
import System.Time.Utils
import Control.Applicative ((<$>))

folding :: Maybe FileInfo -> FileInfo -> Maybe FileInfo
folding Nothing current = Just current
folding (Just best) current
  | metric best > metric current                 = Just best
  | not (Files.isDirectory (infoStatus current)) = Just best -- because isDirectory' would not work
  | otherwise                                    = Just current
  where metric = infoDepth

-- will eliminate hidden directories from recursion, but the `.` dir
notHidden :: FindClause Bool
notHidden = fileName /~? ".?*"

-- isDirectory' :: FindClause Bool
-- isDirectory' = (== Directory) <$> fileType

filterPredicate :: FindClause Bool
filterPredicate = notHidden -- &&? isDirectory' -- this does not filter as expected

main = do
  result <- fold filterPredicate folding Nothing "."
  case result of
    Just info -> putStrLn (infoPath info)
    Nothing -> putStrLn "."
  

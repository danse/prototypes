import Data.List
import System.Posix.Types
import qualified System.Posix.Files as Files
import System.FilePath.Find
import System.Environment
import Control.Monad
import Data.Ord
import System.Time.Utils

data Evaluated = Evaluated {
  path:: FilePath,
  value:: EpochTime
  }

instance Show Evaluated where
  show e = (show (epochToClockTime (value e))) ++ " " ++ (show (path e))

instance Eq Evaluated where
  e1 == e2 = (value e1) == (value e2)

instance Ord Evaluated where
  e1 `compare` e2 = (value e1) `compare` (value e2)

type Metric = FileInfo -> EpochTime

metric :: Metric
metric = Files.modificationTime . infoStatus

folding :: Int -> Metric -> [Evaluated] -> FileInfo -> [Evaluated]
folding size metric previous info
  | accept || best > evaluated = insert evaluated previous
  | otherwise                  = previous
  where best = head previous
        accept = length previous < size
        evaluated = Evaluated {
          path=infoPath info,
          value=metric info
          }

-- will eliminate hidden directories from recursion, but the `.` dir
visible :: FindClause Bool
visible = fileName /~? ".?*"

main = do
  [root] <- getArgs
  results <- fold visible (folding 10 metric) [] root
  sequence $ map print results
  

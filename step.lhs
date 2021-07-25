\begin{code}

import System.Directory (
  listDirectory,
  getModificationTime,
  doesDirectoryExist)
import Data.List (sortOn)
import Data.Time (UTCTime)
import System.FilePath.Posix ((</>))
import Control.Exception (try)
import System.Posix.Files (touchFile)

\end{code}

@WithPrefix@ is used for a relative path that can include parent directories

\begin{code}

newtype WithPrefix = WithPrefix FilePath deriving Show
type FileInfo      = (WithPrefix, UTCTime)

\end{code}

Add information about a path

\begin{code}

addModification :: FilePath -> IO FileInfo
addModification p = do
  t <- getModificationTime p
  return (WithPrefix p, t)

isVisible :: FilePath -> Bool
isVisible p = head p /= '.'

\end{code}

Touching visited directories, we select the file in the current directory that was modified least recently

\begin{code}

latestModified :: FileInfo -> IO (Maybe FileInfo)
latestModified (WithPrefix path, _) = do
  touchFile path
  paths <- listDirectory path
  candidates <- mapM (addModification . (path </>)) (filter isVisible paths)
  return $ if null candidates
    then Nothing
    else Just $ head (sortOn snd candidates)

doesInfoDirectoryExist :: FileInfo -> IO Bool
doesInfoDirectoryExist (WithPrefix path, _) = doesDirectoryExist path

\end{code}

We print the first ten lines of the file. If the file is shorter than ten lines we print a decorator to indicate its end

\begin{code}

filePreview :: FilePath -> UTCTime -> String -> String
filePreview path time = onLines (flip snoc (path <> " " <> show time) . t . f)
  where onLines f = unlines . f . lines
        f = filter (not . null) 
        t l = if length l < previewSize
            then (snoc l decorator)
            else take previewSize l
        snoc :: [a] -> a -> [a]
        snoc l e = l <> [e]
        previewSize :: Int
        previewSize = 10
        decorator :: String
        decorator = replicate 80 '_'

\end{code}

@iterateMWhile@ returns the first value which does not satisfy the predicate, applying the iterator when the predicate is satisfied

\begin{code}

iterateMWhile :: Monad m => (a -> m (Maybe a)) -> (a -> m Bool) -> a -> m a
iterateMWhile iterating predicate initial = do
  pass <- predicate initial
  if pass
    then do
      maybeNext <- iterating initial
      case maybeNext of
        Nothing -> return initial
        Just next -> iterateMWhile iterating predicate next
    else return initial

main :: IO ()
main = do
  a <- getModificationTime "."
  (WithPrefix path, time) <- iterateMWhile latestModified doesInfoDirectoryExist (WithPrefix ".", a)
  eitherContents <- try (readFile path) :: IO (Either IOError String)
  putStrLn $ either show (filePreview path time) eitherContents

\end{code}

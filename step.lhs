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

We select the file in the current directory that was modified least recently. If it points to a directory, we move there and try again

\begin{code}

latestModified :: Maybe FileInfo -> IO (Maybe FileInfo)
latestModified Nothing = return Nothing
latestModified (Just (WithPrefix path, _)) = do
  paths <- listDirectory path
  candidates <- mapM (addModification . (path </>)) (filter isVisible paths)
  return $ if null candidates
    then Nothing
    else Just (head (sortOn snd candidates))

\end{code}

When testing our best candidate we also touch it so that it will not be picked by the next step

\begin{code}

doesMaybeDirectoryExist :: Maybe FileInfo -> IO Bool
doesMaybeDirectoryExist Nothing = return False
doesMaybeDirectoryExist (Just (WithPrefix path, _)) = do
  touchFile path
  doesDirectoryExist path

\end{code}

We print the first ten lines of the file. If the file is shorter than ten lines we print a decorator to indicate its end

\begin{code}

filePreview :: FilePath -> (Either IOError String) -> UTCTime -> String
filePreview path eitherContents time = either show preview eitherContents
  where preview = onLines (flip snoc (path <> " " <> show time) . t . f)
        onLines f = unlines . f . lines
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

iterateMWhile :: Monad m => (a -> m a) -> (a -> m Bool) -> a -> m a
iterateMWhile iterating predicate initial = do
  pass <- predicate initial
  if pass
    then iterating initial >>= \ next -> iterateMWhile iterating predicate next
    else return initial

main :: IO ()
main = do
  a <- getModificationTime "."
  maybeOld <- iterateMWhile latestModified doesMaybeDirectoryExist (Just (WithPrefix ".", a))
  preview <- case maybeOld of
    Nothing -> pure "Empty or hidden directory"
    Just  (WithPrefix path, time) -> do
        eitherContents <- try (readFile path)
        pure $ filePreview path eitherContents time
  putStrLn preview

\end{code}

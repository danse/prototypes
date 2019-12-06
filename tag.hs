{-# LANGUAGE RecordWildCards #-}
import System.Environment (getArgs)
import System.Directory (createDirectoryIfMissing, copyFile, removeFile, getCurrentDirectory)
import System.FilePath.Posix (takeFileName)
import System.Posix.Files (createLink)
import Data.Monoid( (<>) )
import Control.Applicative( some )
import Options.Applicative

link file dir = do
  createDirectoryIfMissing True dir
  createLink file (dir ++ "/" ++ (takeFileName file))

data Options = Options {
  remove :: Bool,
  args :: [String]
  }

singleTag tag file = do
  curr <- getCurrentDirectory
  link file (curr ++ "/tags/" ++ tag ++ "/")

optionParser :: Parser Options
optionParser = Options
               <$> switch (long "remove" <> short 'r')
               <*> some (argument str (metavar "<file1> <file2> ... <tag>"))

tag :: Options -> IO ()
tag Options {..} = 
  let files = init args
      tag = last args
  in do
    sequence (map (singleTag tag) files)
    if remove then sequence (map removeFile files) else pure [()]
    return ()

optionParserInfo :: ParserInfo Options
optionParserInfo = info optionParser fullDesc

main = execParser optionParserInfo >>= tag

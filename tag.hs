{-# LANGUAGE RecordWildCards #-}
import System.Environment (getArgs)
import System.Directory (createDirectoryIfMissing, copyFile, removeFile, getCurrentDirectory)
import System.FilePath.Posix (takeFileName, splitPath)
import System.Posix.Files (createLink)
import Data.Monoid( (<>) )
import Control.Applicative( some )
import Options.Applicative
import Prototypes (takePathEnd)

link file dir = do
  createDirectoryIfMissing True dir
  createLink file (dir ++ "/" ++ (takeFileName file))

data Options = Options {
  remove :: Bool,
  tagPath :: FilePath,
  args :: [String]
  }

singleTag tag file = do
  curr <- getCurrentDirectory
  link file (curr ++ "/tags/" ++ tag ++ "/")

optionParser :: Parser Options
optionParser = Options
               <$> switch (long "remove" <> short 'r')
               <*> strOption (long "tag" <> short 't') -- you can use this option with an existing tag to benefit from prefix completion
               <*> some (argument str (metavar "<file1> <file2> ... <tag>"))

tag :: Options -> IO ()
tag Options {..} = 
  let files = init args
      tag = takePathEnd tagPath
  in do
    sequence (map (singleTag tag) files)
    if remove then sequence (map removeFile files) else pure [()]
    return ()

optionParserInfo :: ParserInfo Options
optionParserInfo = info optionParser fullDesc

main = execParser optionParserInfo >>= tag

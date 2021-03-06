{-# LANGUAGE RecordWildCards #-}
{-
    
  tag a-1 a-2 a
  tag b-1 tags/a/a-1 1

  that's in order to avoid the proliferation of tags. it's going to be
  better for now. later i might want a multitag command

  lines below are old

    ~ $ tag-ingest "file name"
    tags/.contents/"file name"/links
    tags/.contents/"file name"/content
    ~ $ tag-collect-untagged && cd tags/un
    un $ tag tech read "file name" # looks for parent `tags`
    tags/tech/"file name"
    tags/read/"file name"
    tags/.contents/"file name"/links
    tags/.contents/"file name"/content
    un $ cd ..
    tags $ rm tech/"file name" read/"file name"
    tags/.contents/"file name"/links
    tags/.contents/"file name"/content
    tags $ tag-collect-untagged
    tags/un/"file name"
    tags/.contents/"file name"/links
    tags/.contents/"file name"/content
    ~ tag-archive "file name"
    tags/arch/"file name"
    tags/.contents/"file name"/links
    tags/.contents/"file name"/content
    ~ tag-remove "file name"
    tags/
    tags/.contents/

-}

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

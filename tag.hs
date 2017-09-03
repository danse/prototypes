{-
    
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
import System.Directory (createDirectoryIfMissing, copyFile, removeFile)

copyTo file dir = do
  createDirectoryIfMissing True dir
  copyFile file (dir ++ "/" ++ file)

singleTag file tag = copyTo file ("tags/" ++ tag ++ "/")

tag :: [String] -> IO ()
tag args = 
  let tags = init args
      fileName = last args
  in do
    sequence (map (singleTag fileName) tags)
    removeFile fileName

main = do
    args <- getArgs
    tag args


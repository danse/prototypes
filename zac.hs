import System.Environment (getArgs)
import Data.Monoid ((<>))

-- designed usage is:
-- pandoc $(zac location) -o $(zac file)
-- which does not seem to work because execution in $() does not output the arguments so the user experiences more doubts

-- zac = echo + cat
zac :: String -> IO ()
zac a = do
  putStrLn a
  i <- getLine
  putStrLn i

toPrompt [] = "zac value"       <> ": "
toPrompt a  = (foldl (<>) [] a) <> ": "

main = do
  a <- getArgs
  zac (toPrompt a)
  

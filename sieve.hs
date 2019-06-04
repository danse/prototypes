{-# LANGUAGE FlexibleContexts #-}
{- this command currently simply sorts line groups by size -}
import Text.Parsec
import Text.Parsec.Token
import Data.Functor
import Prototypes
import Data.List
import qualified Data.List.NonEmpty as N
import Control.Monad (join, liftM)
import Data.Either (fromRight)

data Expression = Expression String
data Cluster    = Cluster [Expression]
data Net        = Net [Cluster]

sep = "\n"

instance Show Expression where
  show (Expression e) = e
instance Show Cluster where
  show (Cluster c) = intercalate sep $ map show c
instance Show Net where
  show (Net n) = intercalate (sep ++ sep) $ map show n

sortByLength :: Net -> Net
sortByLength (Net n) =
  let clusterLength (Cluster c) = length c
  in Net $ reverse $ sortOn clusterLength n

countExpressions :: Net -> Net
countExpressions (Net n) = Net (map c n)
  where c (Cluster e) = Cluster [Expression $ show $ length e]

line :: Stream s m Char => ParsecT s u m Expression
line = liftM Expression $ many1 $ noneOf sep
cluster :: Stream s m Char => ParsecT s u m Cluster
cluster = liftM Cluster $ endBy line (string sep)
parser :: Stream s m Char => ParsecT s u m Net
parser = liftM Net $ endBy cluster (many1 (string sep))

-- | readNet
--
-- >>> readNet "some text\n\n separated by\n some newlines\n\n"
-- Right "some text\n\n separated by\n some newlines\n\n"
readNet :: String -> Either ParseError Net
readNet = (parse $ parser) "noname" 

gravity :: String -> String
gravity = either show (show . sortByLength) . readNet

profile :: String -> String
profile = either show (show . countExpressions . sortByLength) . readNet

main = do
  contents <- getContents
  putStr (gravity contents)

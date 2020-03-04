{-# LANGUAGE RecordWildCards #-}
import System.Directory (createDirectoryIfMissing, copyFile, removeFile, getCurrentDirectory, getHomeDirectory)
import System.FilePath.Posix (takeDirectory, takeFileName, splitDirectories, splitPath)
import System.FilePath.Glob (namesMatching)
import Data.Set (Set (..), intersection, difference, union, unions, singleton, fromList)
import Data.Map.Strict (Map (..), map, singleton, unionWith, unionsWith, fromListWith, empty, toList)
import Options.Applicative
import Tags (rootDir)

type Title = String
type Tag = String
type Tags = Set Tag
type TagMap = Map Title Tags
data Tagged a b = Tagged { unTagged :: a, empty :: Set b } deriving Show
-- Branch is for mapping the file configuration
data Branch = Branch { tagPath :: FilePath, contentPaths :: [FilePath] } deriving Show

mapUnion :: TagMap -> TagMap -> TagMap
mapUnion = unionWith union

mapUnions :: [TagMap] -> TagMap
mapUnions = unionsWith union

-- works on "a/b/" and "a/b"
readTag :: FilePath -> Tag
readTag = last . splitDirectories 

-- to be defined
readTitle :: FilePath -> Title
readTitle = takeFileName

mapPaths :: [(FilePath, Tags)] -> TagMap
mapPaths = fromListWith union

contained :: FilePath -> IO [Title]
contained dir = namesMatching (dir ++ "/*")

r :: Tag -> [Title] -> [(Tags, Title)]
r t = Prelude.map ( \ c -> (sin, c) )
  where sin = Data.Set.singleton t

homeBranches :: IO [FilePath]
homeBranches = do
  home <- getHomeDirectory
  contained (home ++ "/" ++ rootDir)

collect :: (Tags -> Tags) -> [Tagged Title Tag] -> [Title]
collect match = Prelude.map unTagged . filter (null . match . Main.empty)

onTitles :: (Title -> Title) -> [(Tag, [Title])] -> [(Tag, [Title])]
onTitles transform = Prelude.map (\ (t, c) -> (t, Prelude.map transform c))

fromBranch :: FilePath -> [FilePath] -> TagMap
fromBranch tagPath = mapUnions . Prelude.map tagSingleton
  where tagSingleton titlePath = Data.Map.Strict.singleton title tags
          where tags = Data.Set.singleton (readTag tagPath)
                title = readTitle titlePath

readBranches :: [Branch] -> [Tagged Title Tag]
readBranches = let mapBranch :: Branch -> TagMap
                   mapBranch (Branch tagPath titlePaths) = fromBranch tagPath titlePaths
                   readMap :: TagMap -> [Tagged Title Tag]
                   readMap = Prelude.map (uncurry Tagged) . toList
               in readMap . mapUnions . (Prelude.map mapBranch)

allTags :: [Branch] -> Set Tag
allTags = fromList . Prelude.map (readTag . tagPath)

allTitles = Prelude.map unTagged . readBranches
allSets   = Prelude.map Main.empty . readBranches

walkHome :: IO [Branch]
walkHome = do
  paths <- homeBranches
  sequence (Prelude.map walkBranch paths)
    where walkBranch path = do
            contentPaths <- contained path
            pure (Branch path contentPaths)
          walkBranch :: FilePath -> IO Branch

-- filtering logic modeled after a nand in order to narrow strictly
filterOnly :: Tags -> Tags -> [Tagged Title Tag] -> [Title]
filterOnly all focused = collect (intersection (difference all focused))

select :: Options -> IO [Title]
select Options {..} = do
  branches <- walkHome
  pure (filterOnly (allTags branches) (fromList only) (readBranches branches))

{-
explain :: Options -> [Title] -> Maybe String
explain [] Options {..} = Just $ "no results for tags " ++ only
explain t _ = Nothing
-}

data Options = Options {
  only :: [FilePath]
  }

optionParser :: Parser Options
optionParser = Options
               <$> some (strOption (long "only" <> short 'o'))

optionParserInfo :: ParserInfo Options
optionParserInfo = info optionParser fullDesc

main = execParser optionParserInfo >>= select >>= sequence . Prelude.map putStrLn

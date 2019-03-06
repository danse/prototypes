import Data.List
import Prototypes

-- >>> part 3 "some words"
-- ["som","e w","ord","s"]
part :: Int -> [a] -> [[a]]
part siz []  = []
part siz ele = take siz ele : part siz (drop siz ele)

-- >>> regroup '.' 3 "ab.cd.ef.gh"
-- "abc.def.gh"
regroup :: Eq a => a -> Int -> [a] -> [a]
regroup sep siz = (intercalate [sep]) . (part siz) . (filter (/= sep))

main = pipeLinesThrough (regroup "" 5)

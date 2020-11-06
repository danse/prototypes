
import Data.Functor ((<$>))
import Data.Map (Map, fromList)

data Edge t   = Edge (t, t)            deriving (Show, Read)
data Graph t  = Graph { ungraph :: [Edge (t, t)] } deriving (Show, Read)
data Linked t = Linked (t, [Linked t]) deriving (Show, Read)

f  :: t -> [t] -> Graph t
f hub = Graph . fmap (\ spike -> (hub, spike) )

-- walk one level
w1 :: Graph t -> t -> Linked t
w1 start = filter (uncurry . \ s e -> s == start) . ungraph

-- Eq e => dedup :: [e] -> [e]

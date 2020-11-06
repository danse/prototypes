
import Data.Ratio ((%))

secondsToYear = (/ (pi * 10 * 1000 * 1000)) :: Double -> Double

sommatoria :: (Ord t, Num t) => t -> t
sommatoria n
  | n < 2     = 1
  | otherwise = n + sommatoria (n-1)

va' f r = fromRational (f % sommatoria r)
va  f r = fromRational (f % r) -- value a status
e val funnel r1 r2 = val funnel r2 - val funnel r1

-- `ra = g va f r` to rank from the funnel
g val funnel r1 r2 = val f2 r2 - val funnel r1
  where f2 = funnel - (r2 - r1)

f = 315            -- funnel
r =   6            -- rank
q = va f r         -- quota
b f r = va f r - q -- benchmark
main = putStrLn q


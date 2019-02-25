import Prototypes
import Data.List (sortOn)

main = pipeLinesThrough (sortOn length)

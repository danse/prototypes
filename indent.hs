import Prototypes

dent n
  | n > 0 -> indent n
  | n == 0 -> noop
  | n < 0 -> outdent n

main = do
  n <- parseops
  pipeLinesThrough (dent n)

 grow   :: Char -> [String] -> [String]
 grow c =
  let f l = c : l
  in map f

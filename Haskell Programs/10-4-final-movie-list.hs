import qualified Data.List as L

movies =
  [ "Aeon Flux"
  , "The Black Cat"
  , "Superman"
  , "Stick It"
  , "The Matrix Revolutions"
  , "The Raven"
  , "Inception"
  , "Looper"
  , "Hoodwinked"
  , "Tell-Tale"
  ]


isGood :: String -> Bool
isGood (x:_) = x <= 'M'   -- takes first letter from a String 
isGood _     = False

assess :: String -> String
assess movie = movie ++ " - " ++ assessment
  where assessment = if isGood movie
                     then "Good"
                     else "Bad"

assessMovies :: [String] -> [String]
assessMovies = map assess

assessedMovies :: [String]
assessedMovies = assessMovies movies

main :: IO ()
main = putStrLn (L.intercalate "\n" assessedMovies)

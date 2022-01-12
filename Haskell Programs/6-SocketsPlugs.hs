-- 6. Sockets & Plugs

-- Defining Functions

plus5 :: Int -> Int
plus5 x = x + 5


-- variable name here (we called it number), rather than x.
plus6 :: Int -> Int
plus6 number = number + 6

--  infix operator such as (+), and you want to use it as a prefix function, 
--     you can just wrap it in parentheses. 

plus6' :: Int -> Int
plus6' number = (+) number 6

-- Operator Sections
--   another identical function, but using what’s called a section.
plus6'' :: Int -> Int
plus6'' number = (+6) number

-- commutative property.

-- Here are four functions that are identical in result:


sevenPlus :: Int -> Int
sevenPlus number = (7+) number

sevenPlus' :: Int -> Int
sevenPlus' = (7+)

plusSeven :: Int -> Int
plusSeven number = (+7) number

plusSeven' :: Int -> Int
plusSeven' = (+7)



main :: IO ()

main = do 
  putStrLn ("plus5 = " ++ show (plus5 10))
  putStrLn ("plus6 = " ++ show (plus6 10))
  putStrLn ("plus6' = " ++ show (plus6' 10))
  putStrLn ("plus6'' = " ++ show (plus6'' 10))
  putStrLn ("sevenPlus = " ++ show (sevenPlus 10))
  putStrLn ("sevenPlus' = " ++ show (sevenPlus' 10))
  putStrLn ("plusSeven = " ++ show (plusSeven 10))
  putStrLn ("plusSeven' = " ++ show (plusSeven' 10))

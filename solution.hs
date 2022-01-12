import Control.Monad.State;

-- q1 --

data ByteCode = LOAD_VAL Int
  | WRITE_VAR String
  | READ_VAR  String
  | ADD
  | MULTIPLY
  | RETURN
  deriving (Show)

data MachineState = MachineState { stack :: [Int], variables :: [(String, Int)], returnValue :: Int } deriving (Show)

readVar :: String -> [(String, Int)] -> Int
readVar name variables = let (Just v) = (lookup name variables) in v

writeVar :: String -> Int -> [(String, Int)] -> [(String, Int)]
writeVar name value [] = [(name, value)]

writeVar name value ((name2, value2):tail)
  | (name == name2) = ((name, value):tail)
  | otherwise       = ((name2, value2):(writeVar name value tail))

popStack :: [Int] -> (Int, [Int])
popStack (head:tail) = (head, tail)

runByteCode :: ByteCode -> State MachineState () 

runByteCode (LOAD_VAL v) = do {
    machine     <- get;
    stack       <- return (stack machine);
    variables   <- return (variables machine);
    returnValue <- return (returnValue machine);
    put (MachineState (v:stack) variables returnValue);
}

runByteCode (WRITE_VAR s) = do {
    machine     <- get;
    stack       <- return (stack machine);
    variables   <- return (variables machine);
    returnValue <- return (returnValue machine);
    (value,newStack) <- return (popStack stack);
    newVariables <- return (writeVar s value variables);
    put (MachineState newStack newVariables returnValue)
}

runByteCode (READ_VAR s) = do {
    machine     <- get;
    stack       <- return (stack machine);
    variables   <- return (variables machine);
    returnValue <- return (returnValue machine);
    value       <- return (readVar s variables);
    put (MachineState (value:stack) variables returnValue)
}

runByteCode (ADD) = do {
    machine     <- get;
    stack       <- return (stack machine);
    variables   <- return (variables machine);
    returnValue <- return (returnValue machine);
    (v1,stack1) <- return (popStack stack);
    (v2,stack2) <- return (popStack stack1);
    put (MachineState ((v1 + v2):stack2) variables returnValue)
}

runByteCode (MULTIPLY) = do {
    machine     <- get;
    stack       <- return (stack machine);
    variables   <- return (variables machine);
    returnValue <- return (returnValue machine);
    (v1,stack1) <- return (popStack stack);
    (v2,stack2) <- return (popStack stack1);
    put (MachineState ((v1 * v2):stack2) variables returnValue)
}

runByteCode (RETURN) = do {
    machine     <- get;
    stack       <- return (stack machine);
    variables   <- return (variables machine);
    (v1,stack1) <- return (popStack stack);
    put (MachineState stack1 variables v1)
}

runByteCodes :: [ByteCode] -> State MachineState Int 
runByteCodes [] = do { 
    machine <- get;
    return (returnValue machine);
}

runByteCodes (head:tail) = do { 
    runByteCode head;
    (runByteCodes tail)
}

runProgram :: [ByteCode] -> Int
runProgram program = fst ((runState (runByteCodes program)) (MachineState [] [] 0))

program = [
    LOAD_VAL 1, 
    WRITE_VAR "x", 
    LOAD_VAL 2, 
    WRITE_VAR "y",
    READ_VAR "x",
    LOAD_VAL 1, 
    ADD,
    READ_VAR "y",
    MULTIPLY,
    RETURN]

test = runProgram program

-- q2 --

-- Show and go over the functionality and design choices you've made in Haskell code
-- you've written. This should include at least a rudimentary performance analysis.

-- I will talk about q1.

-- The functionality of q1 is to be a simple bytecode interpreter. There are 6 opcode and each of them has a particular meaning. The code interprets them.

-- I don't get to design the bytecode, but I get to design its implementation, so I will talk about its design.

-- Since interpreting byte code involves changing the state of the machine, it makes sense to use the State Monad to avoid passing states.
-- In order to use the State Monad, I need to have a single type for the machine's state, so I designed the MachineState data type.
-- The design of that data type is driven by the ease of interpreting the byte code. For example, in Haskell, we can easily get to the first element of the list
-- So it makes perfect sense to use a list to represent the stack, with the first element being the top of the stack. That allow O(1) access of the stack top element.

-- It is a trade-off to avoid implementing a fast associative lookup for variable. I could, but that would take a lot of time, and will probably impede the performance
-- of this sample due to implementation complexity.

-- The interpretation of the byte code is straightforward and it looks imperative using the do notation. That is intentional.
-- The byte code does not specify what should happen if the instruction are executed in inappropriate state, so it is intentionally left as pattern not matched.

-- q3 --
-- Haskell data are immutable, so you cannot create a cycle in data. A design like this will not work
-- data Node a = Node { prev :: Node, next :: Node }
-- The only way we could break this cycle is to use an index instead an actual reference to the Node
-- Now the index references an underlying storage, for example, a list
-- We will use -1 to denote the null pointer
data Node a = Node { prev :: Int, next :: Int, top :: Int, item :: a } deriving (Show)

-- Without a good guide, we will simply leave the top node pointing to null, but in principle we can point to any node we wanted.
-- by changing the third argument to the node constructor
createTriplyLinkedList :: [a] -> [Node a]
createTriplyLinkedList list = 
  let l = length(list) in 
    map (\(index, value) -> 
      if index == 0 then (Node (-1) 1 (-1) value) else (
          if index == (l - 1) then (Node (l - 2) (-1) (-1) value) else (Node (index - 1) (index + 1) (-1) value))) 
      (zip [0..(l - 1)] list)

prev_node :: [Node a] -> (Node a) -> Maybe (Node a)
prev_node list node = let p = prev node in 
                if p == -1 then Nothing else Just (list !! p)

next_node :: [Node a] -> (Node a) -> Maybe (Node a)
next_node list node = let n = (next node) in 
                if n == -1 then Nothing else Just (list !! n)

top_node :: [Node a] -> (Node a) -> Maybe (Node a)
top_node list node = let n = (top node) in 
                if n == -1 then Nothing else Just (list !! n)

-- Again, Haskell data are immutable, so you can't change the linked list without changing the underlying list
-- Changing a random element in a Haskell list, however, would take O(N) time, so that is rather useless, you might as well 
-- simply use a Haskell list instead.
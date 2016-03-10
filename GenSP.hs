--
-- Copyright (c) 2016 Max Belov
--
import System.Environment
import System.Exit 
import System.IO.Unsafe(unsafePerformIO)
import System.Directory (doesDirectoryExist, getDirectoryContents, createDirectoryIfMissing)
import System.FilePath ((</>))
import Data.List(intercalate)
import Data.List.Split(splitOn)
import Data.String.Utils(replace)
import Data.Map(fromList,empty,Map,findWithDefault) 
import Control.Monad(forM)
import Control.Exception hiding (try) 
import Text.Regex.TDFA hiding (empty)

getKeyValueFromUser::FilePath -> String -> String
getKeyValueFromUser answers key = unsafePerformIO $ do
    putStrLn  ("What is {-!" ++ key ++ "!-}? : ") 
    value <- getLine 
    appendFile answers (key ++ "=" ++value ++ "\n")
    return value

convertList :: [String] -> (String, String)
convertList [x] = (x, "")
convertList [x,y] = (x, y)
convertList (x:xs) = (x, intercalate "=" xs)

-- Read Answers file, if exists
readAnswers::FilePath -> Map String String
readAnswers answersFile = unsafePerformIO $ handle (\(SomeException _) -> putStrLn "Error reading answers file" >> return empty) $
    do
        inputStream <- readFile answersFile
        return (fromList $ map (convertList . splitOn ("=")) (splitOn ("\n") inputStream))

undecorateKey::String -> String
undecorateKey decoratedKey = replace "!-}" "" $ replace "{-!" "" decoratedKey

-- Replace patterns in the file and directory names
resolvePatterns::String -> String -> String
resolvePatterns key answers = do
    let matches = getAllTextMatches $ key =~ "{-![a-zA-Z0-9-]*!-}" :: [String]
    case length matches of 
        0 -> key
        _ -> foldl (\x y -> replace y (findWithDefault (getKeyValueFromUser answers $ undecorateKey y) (undecorateKey y) (readAnswers answers)) x) key matches

-- Generate project directory
-- Traverses the template directory tree, reads and writes it into the destination directory
-- If encounters a tag in the 
--     a) directory name
--     b) file name
--     c) file body
-- checks if the tag is defined in the dictionary
-- if tag is not defined in the dictionary asks user for the tag value
-- when user enters the tag value, replaces it in the template source and writes in the destination directory then records the 
-- answer to the dictionary
generateProjectDirectory::FilePath -> FilePath -> FilePath -> IO [FilePath]
generateProjectDirectory inp outp answers = do 
    names <- getDirectoryContents inp
    let properNames = filter (`notElem` [".", "..", ".hdevtools.sock"]) names
    paths <- forM properNames $ \name -> do
        let inPath = inp </> name
        let outPath = outp </> resolvePatterns name answers
        isDirectory <- doesDirectoryExist inPath
        if isDirectory
            then do
                createDirectoryIfMissing True outPath
                fmap ([outPath] ++) (generateProjectDirectory inPath outPath answers)
            else do
                -- write input file to the output directory filtering out all patterns
                input <- readFile inPath
                writeFile outPath $ resolvePatterns input answers
                return [outPath]   -- Processed File
    return (concat paths)

-- Generate Sublime Project
gensp::[FilePath] -> IO ()
gensp args
    | length args == 2 = gensp [args !! 0, args !! 1, "./answers.txt"]
    | length args == 3 = do 
        paths <- generateProjectDirectory (args !! 0) (args !! 1) (args !! 2)
        putStrLn $ "Done: \n\t" ++ (paths >>= \x -> x ++ "\n\t")
    | otherwise = putStrLn "Usage: gensp <template directory> <output directory> [<answers file containing records in the form of {key}={value}\\n pairs>]" >> exitFailure

-- Entry Point
main :: IO ()
main = do
    args <- getArgs
    gensp args

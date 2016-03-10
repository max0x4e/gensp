--
-- Dummy stub
--
import System.Environment
import System.Exit
 
-- Business logic
{-!app-name!-}::[FilePath] -> IO ()
{-!app-name!-} args = putStrLn "{-!app-synopsis!-}" >> exitFailure

-- Entry Point
main :: IO ()
main = do
    args <- getArgs
    {-!app-name!-} args        
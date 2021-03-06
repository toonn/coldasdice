{-# LANGUAGE OverloadedStrings #-}

import Options.Applicative
import Data.Semigroup ((<>))
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Data.Char
import Data.List

data Args = Args { wordlist :: String
                 , dicerolls :: String }

args :: Parser Args
args = Args
    <$> strOption
        ( long "wordlist"
       <> short 'l'
       <> metavar "PATH"
       <> help "Diceware word list" )
    <*> strOption
        ( long "dicerolls"
       <> short 'd'
       <> value ""
       <> metavar "ROLLS"
       <> help "String of n*5 digits between 1 and 6, spaces optional" )

rolls :: T.Text -> IO [T.Text]
rolls "" = do
  T.putStrLn "Please enter a dice roll sequence:"
  xs <- T.getLine
  rolls xs
rolls xs = if (T.length $ last rs) == dwIndexLength
             then
               return rs
             else do
               T.putStrLn $ T.pack $ "Rolls not a multiple of " ++
                           (show dwIndexLength)
               return []
  where
    dwIndexLength = 5
    chunk = (T.chunksOf dwIndexLength) . (T.filter (not . isSpace))
    rs = chunk xs

search :: FilePath -> [T.Text] -> IO [T.Text]
search path rs = do
  f <- T.readFile path
  mapM (search' (T.lines f)) rs
  where
    search' :: [T.Text] -> T.Text -> IO T.Text
    search' [] roll = do
      T.putStrLn $ T.pack $ "Missing sequence " ++ T.unpack roll
      return ""
    search' (l:ls) roll = do
      let ws = T.words l
      if length ws == 2 && head ws == roll
      then
        return $ (head . tail) ws
      else
        search' ls roll
                
run :: Args -> IO ()
run as = do
  rs <- rolls $ T.pack $ dicerolls as
  ws <- search (wordlist as) rs
  mapM_ T.putStr $ intersperse " " ws

main :: IO ()
main = run =<< execParser opts
  where
    versionOption = infoOption "ColdAsDice version 1.0" (long "version" <>
                      short 'V' <> help "Show version")
    opts = info (args <**> helper <**> versionOption)
      ( fullDesc
     <> progDesc "search words in a plaintext Diceware WORDLIST"
     <> header "cadice - a Diceware convenience utility" )

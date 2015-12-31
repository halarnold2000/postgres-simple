


--module Main where

-- import           Control.Monad.IO.Class  (liftIO)
-- import           Database.PostgreSQL.Simple
-- import           Database.Persist.Postgresql
-- --import  Data.String.IsString ConnectInfo

-- import           Lib
--
-- data User = User {
--    name :: String,
--    age :: Int,
--    ps :: String
-- } deriving Show
--
-- connStr = "host=localhost dbname=test user='harnold' password='' port=5432"
--
-- main :: IO ()
-- main = withPostgresqlPool connStr 10 $ \pool ->
--     flip runSqlPersistMPool pool $ do
--
--       johnId <- insert $ User "John Doe" $ 35 "password1"
--       janeId <- insert $ User "Jane Doe" $ 21 "blah"
--
--
--
--       john <- get johnId
--       liftIO $ print (john :: User)

{-# LANGUAGE OverloadedStrings #-}

module Main where

import      Database.PostgreSQL.Simple
import      Control.Monad
import      Control.Applicative
import      Control.Monad.IO.Class  (liftIO)
--import      Database.PostgreSQL.Simple.FromRow
--import      Database.PostgreSQL.Simple.FromField
--import      Database.Persist.Postgresql
--import      Lib
import qualified Data.Text as T


data UserDB = UserDB {
    id'  :: Int,
    name :: T.Text,
    ps   :: T.Text
}


-- strDB :: UserDB -> UserDB
-- strDB = UserDB <$> id' <*> name <*> ps

-- instance FromRow UserDB where
--   fromRow = UserDB <$> id' <*> name <*> ps

connStr = "host=localhost dbname=test user='harnold' password='' port=5432"
str :: Int -> T.Text -> T.Text -> String

str id name ps = show (id::Int)
  ++ ", " ++ "for: "
  ++ T.unpack name
  ++ " password is: "
  ++ T.unpack ps

instance Show UserDB where
    show (UserDB id' name ps) =
      "UserDB { id: " ++ show (id'::Int) ++ ", name: " ++ T.unpack name ++ ", password: " ++ T.unpack ps ++ " }n"


main = do
    conn <- connectPostgreSQL connStr

    putStrLn "put in a name"
    name <- getLine
    putStrLn "put in a pswrd"
    ps <- getLine
    -- execute conn "insert into test.users (id', name, ps ) values (?, ?, ?)" ["10" :: String,  "hal" ::String,  T.pack "password" :: T.Text]
    -- execute conn "create table social.userz (id INT, name VARCHAR(80), password VARCHAR(80))" ()
    execute conn "insert into social.userz (id, name, password) values (?, ?, ?)" ["5" :: String, name :: String, ps :: String]
    --executeMany conn "insert into social.userz (id, name, password) values (?, ?, ?)" [("2" :: String, "Simon" :: String, "psword2" :: String), ("3" :: String, "Ulf" :: String, "Password2" :: String)]
    xs <- query_ conn "select id, name, password from social.userz"
    forM_ xs $ \(id, name, ps) -> putStrLn $ str id name ps
    close conn
    
    -- xs is a list of tuples: (id::Int, name::Text, email::Text)
    --xs <- query_ conn "select id, name, ps from users"

    --forM_ xs $ \(id, name, ps) -> putStrLn $ str id name ps

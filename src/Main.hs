module Main where

import Text.Groom
import Mir.Mir
import qualified Data.Aeson as J
import qualified Data.ByteString.Lazy as B
import Mir.Pass.CollapseRefs as P
import Mir.Pass.RewriteMutRef as P
import Mir.Pass.RemoveStorage as P
import Mir.Pass.RemoveBoxNullary as P


main :: IO ()
main = do f <- B.readFile ""
          let c = (J.eitherDecode f) :: Either String Collection
          case c of
            Left msg -> fail $ "Decoding of MIR failed: " ++ msg
            Right coll -> do
              --let passes = P.passMutRefArgs . P.passRemoveStorage . P.passRemoveBoxNullary
              let passes = P.passRemoveBoxNullary
              let fns = passes (functions coll)
              -- DEBUGGING print functions
              -- mapM_ (putStrLn . pprint) fns
              putStrLn $ groom $ fns

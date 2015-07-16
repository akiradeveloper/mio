import System.Environment
import Text.Regex
import System.IO
import Control.Monad
import Data.Bits
import Data.ByteString
import System.Random
import Data.Word

data Direction = R | W deriving Show               
type IOLine = (Direction, Int, Int)

split :: String -> IOLine
split s = 
    let [a,b,c] = splitRegex (mkRegex ",") s in
    (case a of
       "R" -> R 
       "W" -> W,
     read b :: Int,
     read c :: Int)

randomByteString n g = pack $ randomBytes n g
  where randomBytes 0 _ = []
        randomBytes n g = fromIntegral val:randomBytes (n-1) nextG
          where (val, nextG) = next g
-- randomByteString n g = undefined

main = do
    [o, m] <- getArgs
    lines <- fmap (fmap Main.split . lines) System.IO.getContents
    origH <- openFile o ReadWriteMode
    mirrH <- openFile m ReadWriteMode
    forM_ lines $ \(rw, start, len) -> do
      case rw of
        R -> do
          hSeek origH AbsoluteSeek (toInteger $ start `shiftL` 9)
          origDat <- hGet origH (len `shiftL` 9)
          hSeek mirrH AbsoluteSeek (toInteger $ start `shiftL` 9)
          mirrDat <- hGet mirrH (len `shiftL` 9)
          if origDat == mirrDat then return () 
                                else print "read fail"
        W -> do
          g <- getStdGen
          dat <- return $ randomByteString (len `shiftL` 9) g
          hSeek origH AbsoluteSeek (toInteger $ start `shiftL` 9)
          hPut origH dat
          hSeek mirrH AbsoluteSeek (toInteger $ start `shiftL` 9)
          hPut mirrH dat
          return ()

import System.Environment
import Text.Regex
import System.IO
import Control.Monad
import Data.Bits
import Data.ByteString

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

main = do
    [o, m] <- getArgs
    lines <- fmap (fmap Main.split . lines) System.IO.getContents
    origH <- openFile o ReadMode
    mirrH <- openFile m ReadWriteMode
    forM_ lines $ \(rw, start, len) -> do
      case rw of
        R -> do
          hSeek origH AbsoluteSeek (toInteger $ start `shiftL` 9)
          origDat <- hGet origH (len `shiftL` 9)
          mirrDat <- hGet mirrH (len `shiftL` 9)
          print $ if origDat == mirrDat then "" else "read fail"
        W -> do
          dat <- undefined
          hSeek origH AbsoluteSeek (toInteger $ start `shiftL` 9)
          hSeek mirrH AbsoluteSeek (toInteger $ start `shiftL` 9)
          print "write"

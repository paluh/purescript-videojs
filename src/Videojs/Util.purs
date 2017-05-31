module Videojs.Util where

foreign import merge
  :: forall r1 r2 r3
   . Union r1 r2 r3
  => Record r1
  -> Record r2
  -> Record r3

module Videojs.HlsjsP2pSourceHandler where

import Prelude
import Videojs as Videojs
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Exception (EXCEPTION)
import DOM (DOM)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn2, Fn4, runFn4)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype, unwrap)
import Util (merge)
import Videojs (VIDEOJS, Videojs)

foreign import data HLSJS ∷ Effect

newtype StreamrootKey = StreamrootKey String
derive instance newtypeStreamrootKey ∷ Newtype StreamrootKey _
derive instance genericStreamrootKey ∷ Generic StreamrootKey _
instance showStreamrootKey ∷ Show StreamrootKey where
  show = genericShow

type Options = Videojs.OptionsBase (streamrootKey ∷ StreamrootKey)

type HlsjsConfig = { debug ∷ Boolean }
type P2pConfig = { streamrootKey ∷ String }
type Html5 = { hlsjsConfig ∷ HlsjsConfig, p2pConfig ∷ P2pConfig }
type NativeOptions = Videojs.NativeOptionsBase (html5 ∷ Html5)

foreign import videojsImpl ∷
  forall a b eff.
    Fn4 (a -> Either a b) (b -> Either a b) String NativeOptions (Eff (videojs ∷ VIDEOJS, dom ∷ DOM | eff) (Either String Videojs))

foreign import videojsImpl' ∷
  ∀ eff.
    Fn2
      String
      NativeOptions
      (Eff (exception ∷ EXCEPTION, videojs ∷ VIDEOJS, dom ∷ DOM | eff) Videojs)

videojs :: ∀ eff. Options → Eff ( dom ∷ DOM , videojs ∷ VIDEOJS | eff ) (Either String Videojs)
videojs = Videojs.videojsBase (\e → runFn4 videojsImpl Left Right e <<< toNativeOptions)

toNativeOptions ∷ Options → NativeOptions
toNativeOptions options =
  merge o { html5 }
 where
  o = Videojs.toNativeOptions options

  html5 =
    { hlsjsConfig:
        { debug: options.debug }
    , p2pConfig:
        { streamrootKey: unwrap options.streamrootKey }
    }

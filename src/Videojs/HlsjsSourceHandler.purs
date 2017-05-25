module Videojs.HlsjsSourceHandler where

import Videojs as Videojs
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Exception (EXCEPTION)
import DOM (DOM)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn2, Fn4, runFn4)
import Util (merge)
import Videojs (VIDEOJS, Videojs)

foreign import data HLSJS ∷ Effect

type HlsjsConfig = { debug ∷ Boolean }
type Html5 = { hlsjsConfig ∷ HlsjsConfig }
type Options = Videojs.OptionsBase ()
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
videojs = Videojs.videojsBase (\e o → runFn4 videojsImpl Left Right e (toNativeOptions o))

toNativeOptions ∷ Options → NativeOptions
toNativeOptions options =
  merge o { html5: { hlsjsConfig: { debug: options.debug }}}
 where
  o = Videojs.toNativeOptions options

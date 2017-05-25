module VideojsPuxComponent where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import DOM (DOM)
import Data.Function.Uncurried (Fn2)
import Data.Nullable (Nullable, toNullable)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (reactClassWithProps)
import React (ReactClass)
import Videojs (Index, NativePlaylist, NativeWatermark, OptionsBase, VIDEOJS, Videojs, toNativePlaylist, toNativeWatermark)

type VideojsImpl opts =
  ∀ eff. Fn2 String opts (Eff (exception ∷ EXCEPTION, videojs ∷ VIDEOJS, dom ∷ DOM | eff) Videojs)

type VideojsProps opts =
  { options ∷ opts
  , playlist ∷ NativePlaylist
  , playlistItem ∷ Int
  , watermark ∷ Nullable NativeWatermark
  , videojs ∷ VideojsImpl opts
  }

foreign import videoPlayerComponentImpl ∷ ∀ opts. ReactClass (VideojsProps opts)

videojsComponent ∷ ∀ e env opts. VideojsImpl opts → (OptionsBase e → opts) → OptionsBase e → Index → (HTML env → HTML env)
videojsComponent videojs toNativeOptions options playlistIndex =
  reactClassWithProps
    videoPlayerComponentImpl
    "videojs-component"
    { options: toNativeOptions options
    , playlist: toNativePlaylist options.playlist
    , playlistItem: playlistIndex
    , watermark: toNullable $ toNativeWatermark <$> options.watermark
    , videojs: videojs
    }

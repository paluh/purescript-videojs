module VideojsPuxComponent where

import Prelude
import Data.Nullable (Nullable, toNullable)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (reactClassWithProps)
import React (ReactClass)
import Videojs (Index, Options, toNativeOptions, toNativePlaylist, toNativeWatermark, NativeWatermark, NativePlaylist, NativeOptions)

type VideojsProps =
  { options ∷ NativeOptions
  , playlist ∷ NativePlaylist
  , playlistItem ∷ Int
  , watermark ∷ Nullable NativeWatermark
  }

foreign import videoPlayerComponentImpl ∷ ReactClass VideojsProps

videojsComponent ∷ ∀ env. Options → Index → (HTML env → HTML env)
videojsComponent options playlistIndex =
  reactClassWithProps
    videoPlayerComponentImpl
    "videojs-component"
    { options: toNativeOptions options
    , playlist: toNativePlaylist options.playlist
    , playlistItem: playlistIndex
    , watermark: toNullable $ toNativeWatermark <$> options.watermark
    }

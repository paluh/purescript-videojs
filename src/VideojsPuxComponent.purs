module VideojsPuxComponent where

import Data.Nullable (Nullable)
import Pux.Html (Html, Attribute)
import Pux.Html.Attributes (attr)
import Videojs (Index, NativeOptions, NativePlaylist, NativeWatermark)

foreign import videoPlayerComponentImpl
  ∷ ∀ a.
  Array (Attribute a) ->
  Array (Html a) ->
  Html a

videojsComponent ∷ ∀ a. NativeOptions → Nullable NativeWatermark → NativePlaylist → Index → Html a
videojsComponent options watermark playlist playlistIndex =
  videoPlayerComponentImpl
    [ attr "options" options
    , attr "watermark" watermark
    , attr "playlist" playlist
    , attr "playlistItem" playlistIndex
    ]
    []


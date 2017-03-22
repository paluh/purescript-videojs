module VideojsPuxComponent where

import Prelude
import Data.Nullable (toNullable)
import Pux.Html (Html, Attribute)
import Pux.Html.Attributes (attr)
import Videojs (Index, Options, toNativeOptions, toNativePlaylist, toNativeWatermark)

foreign import videoPlayerComponentImpl
  ∷ ∀ a.
  Array (Attribute a) ->
  Array (Html a) ->
  Html a

videojsComponent ∷ ∀ a. Options → Index → Html a
videojsComponent options playlistIndex =
  let
    options' = toNativeOptions options
    playlist = toNativePlaylist options.playlist
    watermark = toNullable $ toNativeWatermark <$> options.watermark
  in
    videoPlayerComponentImpl
      [ attr "options" options'
      , attr "watermark" watermark
      , attr "playlist" playlist
      , attr "playlistItem" playlistIndex
      ]
      []


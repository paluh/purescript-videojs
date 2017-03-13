module PuxComponentSimple where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import DOM.Node.Types (ElementId(..))
import Data.Array (singleton)
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Data.Nullable (toNullable)
import Pux (noEffects, renderToDOM, start)
import Pux.Html (Html, div, text)
import Signal.Channel (CHANNEL)
import Videojs (Playlist, Preload(Metadata), Tech(Html5, Flash), WatermarkPosition(TopLeft), toNativeOptions, toNativePlaylist, toNativeWatermark)
import VideojsPuxComponent (videojsComponent)
import Prelude hiding (div)

playlist :: Playlist
playlist =
    singleton
      { sources:
        { hls: Just "http://stream5.nadaje.com:12146/live/stream-1.stream/playlist.m3u8"
        , rtmp: Just "rtmp://stream5.nadaje.com:12142/live/gmX498.stream?secure-endtime=1487851377.22&secure-hash=w-uKTAaeSEjOcGKm6km-eVFLRrf9WZO1X7jmLW-KbhQ="
        , mpegDash: (Nothing ∷ Maybe String)
        }
      , poster: Just "./static/pimp.JPG"
      }

options =
  { autoPlay: true
  , controlBarVisibility: true
  , debug: true
  , parentId: ElementId "unused"
  , playlist: playlist
  , preload: Metadata
  , techOrder: Flash :| [Html5]
  , watermark
  }

watermark =
  Just
    { url: "./static/khan.png"
    , position: TopLeft
    , fadeOut: Just 25
    }

view ∷ Unit → Html Unit
view _ =
  div []
    [ text "test"
    , videojsComponent options' watermark playlist 0
    ]
 where
  options' = toNativeOptions options
  watermark = toNullable $ toNativeWatermark <$> options.watermark
  playlist = toNativePlaylist options.playlist

run ∷ ∀ eff. String → Eff (channel ∷ CHANNEL, err ∷ EXCEPTION | eff) Unit
run parentId = do
  app ← start
    { initialState: unit
    , update: (\_ s → noEffects s)
    , view: view
    , inputs: []
    }
  renderToDOM ("#" <> parentId) app.html
  pure unit

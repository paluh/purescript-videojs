module Simple where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM (DOM)
import DOM.Node.Types (ElementId(..))
import Data.Array (singleton)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Videojs (Preload(..), Tech(..), VIDEOJS, WatermarkPosition(..), videojs)

run :: forall eff. String → Eff ( console :: CONSOLE, videojs :: VIDEOJS, dom :: DOM | eff ) Unit
run elementId = do
  result <-
    videojs
      { autoPlay: false
      , controlBarVisibility: true
      , debug: true
      , parentId: ElementId elementId
      , playlist:
          singleton
            { sources:
              { hls: Just "http://stream5.nadaje.com:12146/live/stream-1.stream/playlist.m3u8"
              , rtmp: Just "rtmp://stream5.nadaje.com:12142/live/gmX498.stream?secure-endtime=1487851377.22&secure-hash=w-uKTAaeSEjOcGKm6km-eVFLRrf9WZO1X7jmLW-KbhQ="
              -- , rtmp: Just "rtmp://127.0.0.1:20222/live/test.stream?secure-end_time=1487858692.2&secure-hash=mFakhb2DOpQYXUr5lHWUK_72Dvev_yLEZ8R--q8DZFg="
              , mpegDash: (Nothing ∷ Maybe String)
              }
            , poster: Just "./static/pimp.JPG"
            }
      , preload: Metadata
      , techOrder: Flash :| [Html5]
      , watermark:
        Just
          { url: "./static/khan.png"
          , position: TopLeft
          , fadeOut: Just 25
          }
      }
  case result of
    Left err -> log err
    Right v -> log "Purescript FTW!"


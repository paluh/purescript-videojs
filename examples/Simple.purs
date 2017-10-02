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
import Videojs (Preload(..), Tech(..), VIDEOJS, WatermarkPosition(..))
import Videojs.HlsjsSourceHandler (videojs)

run :: forall eff. String → Eff ( console :: CONSOLE, videojs :: VIDEOJS, dom :: DOM | eff ) Unit
run elementId = do
  result <-
    videojs
      { autoPlay: true
      , controlBarVisibility: true
      , debug: true
      , parentId: ElementId elementId
      , playlist:
          singleton
            { sources:
              { hls: Just "https://nadaje.delivery.streamroot.io/nadaje4/live/ngrp:stream-1_all/chunklist_b520071.m3u8?e=1507044002&st=9g8oiIBWfMXcPpHRiN7nTg"
                -- hls: Just "http://stream5.nadaje.com:12146/live/stream-1.stream/playlist.m3u8kurwa"
              , rtmp: Nothing
              -- , rtmp: Just "http://stream5.nadaje.com:12146/live/stream-1.stream/playlist.m3u8?secure-endtime=1505320281&secure-hash=pb9_qUHe95llPzqL8RPHVkjaYmI5ZRnU6TBKQdgRaFk=" --"rtmp://stream5.nadaje.com:12146/live/stream-1.stream"
              -- , rtmp: Just "rtmp://stream4-clone.nadaje.com:8000/live/TZQ1.stream?secure-endtime=1489851043&secure-hash=2brsbcMbBOvhWyq8wmD2pUpySlFbAGwMZUNyseE1tdQ="
              -- , rtmp: Just "rtmp://stream4-clone.nadaje.com:8000/live/TZQ1.stream?secure-hash=Nytl15fQ4vzozz48mOY4I09sAsH6AJyVJIqe0USi5Rk="

              -- , rtmp: Just "rtmp://127.0.0.1:20222/live/test.stream?secure-end_time=1487858692.2&secure-hash=mFakhb2DOpQYXUr5lHWUK_72Dvev_yLEZ8R--q8DZFg="
              , mpegDash: (Nothing ∷ Maybe String)
              }
            , poster: Just "./static/pimp.JPG"
            }
      , preload: Metadata
      , techOrder: Flash :| [Html5] -- Html5 :| [Flash]
      , watermark:
        Just
          { url: "./static/khan.png"
          , position: TopLeft
          , fadeOut: Just 25
          }
      }
  case result of
    Left err -> log ("ERROR" <> show err)
    Right v -> log "Purescript FTW!"


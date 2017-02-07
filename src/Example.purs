module Example where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM (DOM)
import DOM.Node.Types (ElementId(..))
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Data.Nullable (toNullable)
import Videojs (Preload(..), Tech(..), VIDEOJS, WatermarkPosition(..), videojs)

run :: forall eff. Eff ( console :: CONSOLE, videojs :: VIDEOJS, dom :: DOM | eff ) Unit
run = do
  result <-
    videojs
      { autoPlay: false
      , controlBarVisibility: true
      , debug: true
      , parentId: ElementId "player"
      , playlist:
        [ { sources:
            [ { type: "application/x-mpegurl"
              , src: "http://stream5.nadaje.com:12146/live/stream-1.stream/playlist.m3u8"
              }
            , { type: "rtmp/mp4"
              , src: "rtmp://stream5.nadaje.com:12146/live/stream-1.stream"
              }
            ]
          , poster: toNullable Nothing
          }
        ]
      , preload: Metadata
      , techOrder: Html5 :| [Flash]
      , watermark:
        Just
          { url: "./static/khan.png"
          , position: TopLeft
          , fadeOut: Just 25
          }
      }
  case result of
    Left err -> log err
    Right v -> log "very new FTW "


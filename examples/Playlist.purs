module Playlist where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM (DOM)
import DOM.Node.Types (ElementId(..))
import Data.Array (fromFoldable)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Data.Nullable (toNullable)
import Partial.Unsafe (unsafePartial)
import Videojs (Preload(..), Tech(..), VIDEOJS, Videojs, WatermarkPosition(..), videojs)


run :: forall eff. Eff ( console :: CONSOLE, videojs :: VIDEOJS, dom :: DOM | eff ) Videojs
run = do
  result <-

    -- var Name = name.charAt(0).toUpperCase() + name.slice(1);
    -- console.log(player.controlBar.childNameIndex_);
    videojs
      { autoPlay: false
      , controlBarVisibility: true
      , debug: false
      , parentId: ElementId "player"
      , playlist:
          fromFoldable
            [ { sources:
                { hlsUrl: Just "http://stream6.nadaje.com:14968/live/ngrp:test.stream_all/playlist.m3u8"
                , rtmpUrl: Nothing
                , mpegDashUrl: Nothing
                }
              , poster: toNullable $ Just "https://nadaje.com/static/upload/splashes/P1020758.JPG"
              }
            , { sources:
                { hlsUrl: Just "http://stream6.nadaje.com:14968/live/ngrp:iGF603.stream_all/playlist.m3u8"
                , rtmpUrl: Nothing
                , mpegDashUrl: Nothing
                }
              , poster: toNullable $ Just "https://nadaje.com/static/upload/splashes/lidl.jpg"
              }
            , { sources:
                { hlsUrl: Just "http://stream6.nadaje.com:14968/live/ngrp:VpN604.stream_all/playlist.m3u8"
                , rtmpUrl: Nothing
                , mpegDashUrl: Nothing
                }
              , poster: toNullable $ Just "https://nadaje.com/static/upload/splashes/P1020763.JPG"
              }
            , { sources:
                { hlsUrl: Just "http://stream6.nadaje.com:14968/live/ngrp:test-12.stream_all/playlist.m3u8"
                , rtmpUrl: Nothing
                , mpegDashUrl: Nothing
                }
              , poster: toNullable $ Just "https://nadaje.com/static/upload/splashes/mandelbrot.jpg"
              }
            , { sources:
                { hlsUrl: Just "http://stream6.nadaje.com:14968/live/ngrp:RWW605.stream_all/playlist.m3u8"
                , rtmpUrl: Nothing
                , mpegDashUrl: Nothing
                }
              , poster: toNullable $ Just "https://nadaje.com/static/upload/splashes/P1020730_xgntXJj.JPG"
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
  unsafePartial $ case result of
    -- Left err -> log err
    Right v -> do
      log "initialization succeeded"
      pure v


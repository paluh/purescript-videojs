module Snc where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM (DOM)
import DOM.Node.Types (ElementId(..))
import Data.Array (singleton)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn5, runFn5)
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Videojs (Preload(..), Tech(..), VIDEOJS, WatermarkPosition(..), videojs)

-- foreign import initChatImpl ∷ ∀ eff. Eff (console ∷ CONSOLE | eff) Unit

type PrebindUrl = String
type BoshServiceUrl = String
type Room = String
type Jid = String
type Nick = String

foreign import initChatImpl ::
  forall eff.
    Fn5 PrebindUrl BoshServiceUrl Room Jid Nick (Eff (dom :: DOM | eff) Unit)

--initChat = runFn5 initChatImpl
--  log "INIT CHAT"

type ElementIdValue = String
type Hls = String
type Rtmp = String
type Poster = String
type Watermark = String

initVideo :: forall eff. ElementIdValue → Hls → Rtmp → Poster → Watermark → Eff ( console :: CONSOLE, videojs :: VIDEOJS, dom :: DOM | eff ) Unit
initVideo elementId hls rtmp poster watermark = do
  result <-
    videojs
      { autoPlay: false
      , controlBarVisibility: true
      , debug: true
      , parentId: ElementId elementId
      , playlist:
          singleton
            { sources:
              { hls: Just hls
              , rtmp: Just rtmp
              , mpegDash: (Nothing ∷ Maybe String)
              }
            , poster: Just poster
            }
      , preload: Metadata
      , techOrder: Html5 :| [Flash]
      , watermark:
        Just
          { url: watermark
          , position: TopLeft
          , fadeOut: Just 25
          }
      }
  case result of
    Left err -> log err
    Right v -> log "Purescript FTW!"


module Videojs where

import Prelude
import DOM.HTML.Window as Window
import Control.Monad.Eff (Eff)
import DOM (DOM)
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToDocument)
import DOM.Node.Document (createElement)
import DOM.Node.Element (setAttribute, setId)
import DOM.Node.Node (appendChild)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (elementToNode, documentToNonElementParentNode, Element, ElementId(ElementId), Document)
import Data.Argonaut.Decode (decodeJson, class DecodeJson)
import Data.Array (catMaybes, fromFoldable)
import Data.Either (Either(Left, Right))
import Data.Function.Uncurried (Fn2, Fn4, runFn4, runFn2)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe(Just, Nothing))
import Data.NonEmpty (NonEmpty)
import Data.Nullable (toNullable, toMaybe, Nullable)

data Videojs
foreign import data VIDEOJS :: !

-- `Auto` - player triggers preloading on browsers/devices which allow it
-- `Metadata` - preload only metadata
-- `None` - do not load anything
data Preload = Auto | Metadata | None
preloadToNative :: Preload -> String
preloadToNative Auto = "auto"
preloadToNative Metadata = "metadata"
preloadToNative None = "none"

data WatermarkPosition = TopLeft | TopRight | BottomRight | BottomLeft
derive instance genericWatermarkPosition ∷ Generic WatermarkPosition _
instance decodeJsonWatermarkPosition :: DecodeJson (WatermarkPosition) where
  decodeJson json =
    decodeJson json >>= decode
   where
    decode "top-left" = Right TopLeft
    decode "top-right" = Right TopRight
    decode "bottom-right" = Right BottomRight
    decode "bottom-left" = Right BottomLeft
    decode _ = Left "Incorrect watermark position value"
instance showWatermarkPosition :: Show WatermarkPosition where
  show = genericShow

type Watermark =
  { url :: String
  , position :: WatermarkPosition
  , fadeOut :: Maybe Int
  }

type ParentId = ElementId
type PlayerId = ElementId

runElementId :: ElementId -> String
runElementId (ElementId eId) = eId

type Sources =
  { rtmp ∷  Maybe String
  , hls ∷  Maybe String
  , mpegDash ∷  Maybe String
  }

type PlaylistItemBase sources poster =
  { sources ∷ sources
  , poster ∷ poster
  }

type PlaylistBase sources poster = Array (PlaylistItemBase sources poster)

type Playlist = PlaylistBase Sources (Maybe String)

type NativePlaylist =
  PlaylistBase (Array { type :: String, src :: String }) (Nullable String)

data Tech = Flash | Html5

techToNative :: Tech -> String
techToNative Flash = "flash"
techToNative Html5 = "html5"

type Options =
  { autoPlay :: Boolean
  , parentId :: ParentId
  , controlBarVisibility :: Boolean
  -- , aspectRatio :: AspectRatio
  , debug :: Boolean
  , playlist :: Playlist
  , preload :: Preload
  , techOrder :: NonEmpty Array Tech
  , watermark :: Maybe Watermark
  -- , width :: Maybe Width
  }

type NativeWatermark =
  { image :: String
  , fadeOut :: Maybe Int
  , position :: String
  }

type HlsjsConfig =
  { debug :: Boolean }

type NativeOptions =
  { autoplay :: Boolean
  , controls :: Boolean
  , preload :: String
  , flash ∷ { swf ∷ String }
  , fluid ∷ Boolean
  , html5 :: { hlsjsConfig :: HlsjsConfig }
  , techOrder :: Array String
  }

foreign import videojsImpl ::
  forall a b eff.
    Fn4 (a -> Either a b) (b -> Either a b) String NativeOptions (Eff (videojs :: VIDEOJS, dom :: DOM | eff) (Either String Videojs))

foreign import playlistImpl ::
  forall eff.
    Fn2 Videojs NativePlaylist (Eff (videojs :: VIDEOJS, dom :: DOM | eff) Unit)
playlist :: forall eff. Videojs -> NativePlaylist -> Eff (videojs :: VIDEOJS, dom :: DOM | eff) Unit
playlist = runFn2 playlistImpl

foreign import watermarkImpl ::
  forall eff.
    Fn2 Videojs (Nullable NativeWatermark) (Eff (videojs :: VIDEOJS, dom :: DOM | eff) Unit)
watermark ∷
  ∀ eff. Videojs →
  Nullable NativeWatermark →
  Eff (videojs :: VIDEOJS, dom :: DOM | eff) Unit
watermark = runFn2 watermarkImpl

type Index = Int

foreign import playlistItemImpl ::
  forall eff.
    Fn2 Videojs Index (Eff (dom :: DOM, videojs :: VIDEOJS | eff) Index)
playlistItem :: forall e. Videojs -> Index -> Eff (dom :: DOM, videojs :: VIDEOJS | e) Index
playlistItem v index = runFn2 playlistItemImpl v index

createVideoElement ::
  forall eff.
    Document ->
    PlayerId  ->
    Eff (dom :: DOM | eff) Element
createVideoElement document playerId = do
  videoElement <- createElement "video" document
  setId playerId videoElement
  setAttribute "class" "video-js vjs-default-skin vjs-fluid vjs-16-9" videoElement
  pure videoElement

videojs :: ∀ eff. Options → Eff (dom :: DOM, videojs :: VIDEOJS | eff) (Either String Videojs)
videojs options = do
  document <- window >>= ((htmlDocumentToDocument <$> _) <<< Window.document)
  let
    rawParentId = runElementId options.parentId
    rawPlayerId = rawParentId <> "-video"
    playerId = ElementId rawPlayerId
  videoElement <- createVideoElement document playerId
  maybeParentElement <- toMaybe <$> getElementById options.parentId (documentToNonElementParentNode document)
  case maybeParentElement of
    Nothing -> pure <<< Left $ "Parent element not found: " <> rawParentId
    Just parentElement -> do
      appendChild (elementToNode videoElement) (elementToNode parentElement)
      result <- runFn4 videojsImpl Left Right rawPlayerId (toNativeOptions options)
      case result of
        Right v -> do
          (playlist v (toNativePlaylist options.playlist))
          (watermark v (toNullable $ toNativeWatermark <$> options.watermark))
          pure result
        err -> pure result

toNativeOptions ∷ Options → NativeOptions
toNativeOptions options =
  { autoplay: options.autoPlay
  , controls: options.controlBarVisibility
  , flash: {swf: "//vjs.zencdn.net/swf/5.2.0/video-js.swf"}
  , fluid: true
  , html5: { hlsjsConfig: { debug: options.debug } }
  , preload: preloadToNative options.preload
  , techOrder: fromFoldable <<< map techToNative $ options.techOrder
  }

toNativePlaylist ∷ Playlist → NativePlaylist
toNativePlaylist =
  map toPlaylistItem
 where
  fromSources sources =
    ((catMaybes
      [ {src: _, type: "rtmp/mp4"} <$> sources.rtmp
      , {src: _, type: "application/x-mpegurl"} <$> sources.hls
      , {src: _, type: "application/dash+xml"} <$> sources.mpegDash
      ]) :: Array { src:: String, type:: String })
  toPlaylistItem { poster, sources } = { poster: toNullable poster, sources: fromSources sources }

toNativeWatermark :: Watermark -> NativeWatermark
toNativeWatermark { fadeOut, url, position }  =
  { fadeOut, position: serPosition position, image: url }
 where
  serPosition TopRight = "top-right"
  serPosition TopLeft = "top-left"
  serPosition BottomLeft = "bottom-left"
  serPosition BottomRight = "bottom-right"


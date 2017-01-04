module Videojs where

import Prelude
import DOM.HTML.Window as Window
import Control.Monad.Eff (Eff)
import Data.Newtype (class Newtype)
import DOM (DOM)
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToDocument)
import DOM.Node.Document (createElement)
import DOM.Node.Element (setAttribute, setId)
import DOM.Node.Node (appendChild)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (elementToNode, documentToNonElementParentNode, Element, ElementId(ElementId), Document)
import Data.Argonaut.Decode (decodeJson, class DecodeJson)
import Data.Argonaut.Decode.Combinators ((.??), (.?))
import Data.Either (Either(Left, Right))
import Data.Function.Uncurried (Fn2, Fn4, runFn4, runFn2)
import Data.Generic (class Generic, gShow)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Nullable (toNullable, toMaybe, Nullable)

data Videojs
foreign import data VIDEOJS :: !

newtype AutoPlaybackMode = AutoPlaybackMode Boolean
derive instance newtypeAutoPlaybackMode :: Newtype AutoPlaybackMode _

newtype ControlBarVisibility = ControlBarVisibility Boolean
derive instance controlBarVisibility :: Newtype ControlBarVisibility _

data WatermarkPosition = TopLeft | TopRight | BottomRight | BottomLeft
derive instance genericWatermarkPosition :: Generic WatermarkPosition
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
  show = gShow

type Watermark =
  { url :: String
  , position :: WatermarkPosition
  , fadeOut :: Maybe Int
  }

type ParentId = ElementId
type PlayerId = ElementId

runElementId :: ElementId -> String
runElementId (ElementId eId) = eId

type PlaylistItem =
  { sources ::
      -- make this type a record
      Array
        { src :: String
        , type :: String
        }
  , poster :: Nullable String
  }
type Playlist = Array PlaylistItem

type Options =
  { autoPlay :: AutoPlaybackMode
  , parentId :: ParentId
  , controlBarVisibility :: ControlBarVisibility
  -- , aspectRatio :: AspectRatio
  , playlist :: Playlist
  , watermark :: Maybe Watermark
  -- , width :: Maybe Width
  }

type NativeWatermark =
  { url :: String
  , fadeOut :: Maybe Int
  , position :: String
  }

type NativeOptions =
  { autoplay :: AutoPlaybackMode
  , controls :: ControlBarVisibility
  , watermark :: Nullable NativeWatermark
  }

foreign import videojsImpl ::
  forall a b eff.
    Fn4 (a -> Either a b) (b -> Either a b) String NativeOptions (Eff (videojs :: VIDEOJS, dom :: DOM | eff) (Either String Videojs))

foreign import playlistImpl ::
  forall eff.
    Fn2 Videojs Playlist (Eff (videojs :: VIDEOJS, dom :: DOM | eff) Unit)
playlist :: forall eff. Videojs -> Playlist -> Eff (videojs :: VIDEOJS, dom :: DOM | eff) Unit
playlist = runFn2 playlistImpl

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

videojs :: forall eff. Options -> Eff (dom :: DOM, videojs :: VIDEOJS | eff) (Either String Videojs)
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
      let
        nativeOptions =
          { autoplay: options.autoPlay
          , controls: options.controlBarVisibility
          , watermark: toNullable (toNativeWatermark <$> options.watermark)
          }
      appendChild (elementToNode videoElement) (elementToNode parentElement)
      result <- runFn4 videojsImpl Left Right rawPlayerId nativeOptions
      case result of
        Right v -> do
          (playlist v options.playlist)
          pure result
        err -> pure result
 where
  toNativeWatermark :: Watermark -> NativeWatermark
  toNativeWatermark watermark =
    watermark { position = serPosition watermark.position}
   where
    serPosition TopRight = "top-right"
    serPosition TopLeft = "top-left"
    serPosition BottomLeft = "bottom-left"
    serPosition BottomRight = "bottom-right"


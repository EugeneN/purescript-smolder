module Text.Smolder.Renderer.Util
  ( renderMarkup
  , Node(..)
  ) where

import Prelude

import Data.Maybe
import Data.Tuple
import Data.List

import qualified Data.Map as Map
import qualified Text.Smolder.Markup as Markup

data Node
  = Element String (Map.Map String String) (List Node)
  | Text String
  | HtmlEntity String

renderMarkup :: forall a. Markup.MarkupM a -> List Node
renderMarkup (Markup.Element name (Just children) attrs rest) =
  Element name (renderAttrs attrs) (renderMarkup children) : renderMarkup rest
renderMarkup (Markup.Element name Nothing attrs rest) =
  Element name (renderAttrs attrs) Nil : renderMarkup rest
renderMarkup (Markup.Content text rest) = Text text : renderMarkup rest
renderMarkup (Markup.HtmlEntity text rest) = HtmlEntity text : renderMarkup rest
renderMarkup (Markup.Return _) = Nil

renderAttrs :: Array Markup.Attr -> Map.Map String String
renderAttrs = Map.fromList <<< map toTuple <<< toList
  where
  toTuple (Markup.Attr key value) = Tuple key value

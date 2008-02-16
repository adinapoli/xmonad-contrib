-----------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Prompt.Theme
-- Copyright   :  (C) 2007 Andrea Rossato
-- License     :  BSD3
--
-- Maintainer  :  andrea.rossato@unibz.it
-- Stability   :  unstable
-- Portability :  unportable
--
-- A prompt for changing the theme of the current workspace
-----------------------------------------------------------------------------

module XMonad.Prompt.Theme
    ( -- * Usage
      -- $usage
      themePrompt,
    ) where

import Control.Arrow ( (&&&) )
import qualified Data.Map as M
import Data.Maybe ( fromMaybe )
import Data.List
import XMonad
import XMonad.Prompt
import XMonad.Layout.Decoration
import XMonad.Util.Themes

-- $usage
-- You can use this module with the following in your
-- @~\/.xmonad\/xmonad.hs@:
--
-- > import XMonad.Prompt
-- > import XMonad.Prompt.Theme
--
-- in your keybindings add:
--
-- >   , ((modMask x .|. controlMask, xK_t), themePrompt defaultXPConfig)
--
-- For detailed instruction on editing the key binding see
-- "XMonad.Doc.Extending#Editing_key_bindings".

data ThemePrompt = ThemePrompt

instance XPrompt ThemePrompt where
    showXPrompt ThemePrompt = "Select a theme: "
    commandToComplete _ c = c
    nextCompletion _ c l = l !! idx
        where idx = case c `elemIndex` l of
                      Just i  -> if i >= length l - 1 then 0 else i + 1
                      Nothing -> 0

themePrompt :: XPConfig -> X ()
themePrompt c = mkXPrompt ThemePrompt c (const . return . map ppThemeInfo $ listOfThemes) changeTheme
    where changeTheme t = sendMessage . SetTheme . fromMaybe defaultTheme $ M.lookup t mapOfThemes

mapOfThemes :: M.Map String Theme
mapOfThemes = M.fromList . uncurry zip . (map ppThemeInfo &&& map theme) $ listOfThemes

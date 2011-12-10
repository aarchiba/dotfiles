import XMonad
import XMonad.Hooks.DynamicLog
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.Scratchpad
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Actions.WindowBringer
import System.IO

myTerminal = "urxvt"
myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]
myLayouts = (smartBorders $ avoidStruts $
                        Full
                        ||| spiral (8/10) 
                        ||| Tall 1 (3/100) (10/12) 
                        )


main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/peridot/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = scratchpadManageHookDefault 
                   <+> manageDocks 
                   <+> myManageHook 
                   <+> manageHook defaultConfig
        , layoutHook = myLayouts
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
        , terminal = myTerminal
        } `additionalKeysP`
        [ ("<Print>", spawn "scrot")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 1- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 1+ unmute")
        , ("<XF86Calculator>", windows $ W.greedyView "1")
        , ("<XF86HomePage>", windows $ W.greedyView "2")
        , ("<XF86Mail>", windows $ W.greedyView "3")
        , ("M-`", scratchpadSpawnActionTerminal "urxvt")
        , ("M-g", gotoMenu)
        , ("M-b", bringMenu)
        , ("M4-l", spawn "xscreensaver-command -lock")
        ]

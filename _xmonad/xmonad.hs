import XMonad
import XMonad.Hooks.DynamicLog
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Layout.NoBorders
import System.IO

myTerminal = "xfce4-terminal"
myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]


main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/peridot/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook = smartBorders $ avoidStruts  $  layoutHook defaultConfig
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
        , ("M4-l", spawn "xscreensaver-command -lock")
        ]

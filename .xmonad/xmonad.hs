import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Replace
import XMonad.Layout.NoBorders

import qualified Data.Map as M
import qualified XMonad.StackSet as W

main = do
	replace
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc"
	xmonad $ defaultConfig
		{ keys          = keys_
		, mouseBindings = mouse_

		, terminal = terminal_

		, workspaces = map show [1 .. 10 :: Int]

		, borderWidth        = 1
		, normalBorderColor  = "black"
		, focusedBorderColor = "darkgray"
		, focusFollowsMouse  = False
		, clickJustFocuses   = False

		, manageHook = manageDocks <+> shifts_<+> (isFullscreen --> doFullFloat) <+> manageHook defaultConfig 
		, layoutHook = smartBorders . avoidStruts $ layoutHook defaultConfig
		, handleEventHook = docksEventHook <+> fullscreenEventHook <+> handleEventHook defaultConfig
		}

terminal_ = "urxvtc"

mouse_ conf@(XConfig {}) = M.fromList []

keys_ conf@(XConfig {}) = M.fromList $
	[ 
	  ((supm, xK_w), spawn "(killall xmobar && xmonad --restart) || xmonad --restart")

	, ((supm          , xK_j)      , windows W.focusDown)
	, ((supm          , xK_k)      , windows W.focusUp)
	, ((supm .|. shim , xK_j)      , windows W.swapDown)
	, ((supm .|. shim , xK_k)      , windows W.swapUp)
	, ((supm          , xK_space)  , windows W.focusMaster)
	, ((supm .|. shim , xK_space)  , windows W.swapMaster)
	, ((supm          , xK_h)      , sendMessage Shrink)
	, ((supm          , xK_l)      , sendMessage Expand)
	, ((supm          , xK_Return) , sendMessage NextLayout)

	, ((supm          , xK_b)      , sendMessage ToggleStruts)

	, ((supm, xK_q), kill)

	, ((altm, xK_Return), spawn "dmenu_run")

	, ((altm, xK_F1), spawn "systemctl suspend")
	, ((altm, xK_F2), spawn "i3lock -uc 000000")

	, ((altm, xK_bracketleft), spawn "xbacklight -dec 10")
	, ((altm, xK_bracketright), spawn "xbacklight -inc 10")
	, ((altm, xK_minus), spawn "xbacklight -dec 100")
	, ((altm, xK_equal), spawn "xbacklight -inc 100")

	, ((altm, xK_comma), spawn "ponymix toggle")

	, ((altm, xK_e), spawn $ terminal_ ++ " -title urxvt")
--	, ((altm, xK_r), spawn "firefox")
	, ((altm, xK_r), spawn "qutebrowser")
	, ((altm, xK_d), spawn $ term "irssi -c localhost")
--	, ((altm, xK_d), spawn "pidgin")
--	, ((altm, xK_z), spawn $ term "ncmpcpp")
	, ((altm, xK_x), spawn $ term "mutt")
	, ((altm, xK_c), spawn $ term "pulsemixer")
	, ((altm, xK_o), restart "/home/cptj/.xmonad/obx.sh" True)
	]
	++
	[((m .|. supm, k), windows $ f i)
		| (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_grave])
		, (f, m) <- [(W.greedyView, 0), (W.shift, shim)]]
	++
	[((m .|. supm, k), screenWorkspace s >>= flip whenJust (windows . f))
		| (k, s) <- zip [xK_e, xK_r] [0..]
		, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

term :: String -> String
term s = terminal_ ++ " -title " ++ s ++ " -e " ++ s

altm = mod1Mask
supm = mod4Mask
shim = shiftMask

shifts_ = (composeAll
	[ --className =? "Firefox"      --> doShift "2"
	 title     =? "qutebrowser"  --> doShift "2"
--	, title     =? "urxvt"        --> doShift "1"
--	, roleName  =? "buddy_list"   --> doShift "4"
--	, roleName  =? "conversation" --> doShift "4"
--	, title     =? "ncmpcpp"      --> doShift "3"
	, title     =? "pulsemixer"   --> doShift "3"
	, title     =? "mutt"         --> doShift "3"
	])

roleName = stringProperty "WM_WINDOW_ROLE"

--TODO newsbeuter


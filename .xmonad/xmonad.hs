import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Scratchpad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Replace
import XMonad.Layout.NoBorders

import qualified Data.Map as M
import qualified XMonad.StackSet as W

import Data.Time

main = do
	replace
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc"
	xmonad $ defaultConfig
--main =
--	xmonad =<< statusBar "xmobar ~/.xmonad/xmobarrc" $ defaultConfig
		{ keys          = keys_
		, mouseBindings = mouse_

		, terminal = terminal_

		, workspaces = map show [1 .. 10 :: Int]

		, borderWidth        = 1
		, normalBorderColor  = "black"
		, focusedBorderColor = "darkgray"
		, focusFollowsMouse  = False
		, clickJustFocuses   = False

		, manageHook = manageDocks <+> shifts_<+> (isFullscreen --> doFullFloat) <+> manageHook defaultConfig <+> manageScratchPad
		, layoutHook = smartBorders . avoidStruts $ layoutHook defaultConfig
		, handleEventHook = docksEventHook <+> fullscreenEventHook <+> handleEventHook defaultConfig

		, startupHook = spawn $ message "echo" 0
		}

manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
	where
		h = 0.4
		w = 0.8
		t = 0
		l = (1 - w)/2

terminal_ = "urxvtc"

mouse_ conf@(XConfig {}) = M.fromList []

keys_ conf@(XConfig {}) = M.fromList $
	[ 
	  ((supm, xK_w), spawn "(killall xmobar && xmonad --restart) || xmonad --restart")
--	  ((supm, xK_w), spawn "xmonad --restart")

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

--	, ((altm, xK_Return), spawn "dmenu_run")
	, ((altm, xK_Return), scratchpadSpawnActionTerminal terminal_)

	, ((altm, xK_F1), spawn "systemctl suspend")
	, ((altm, xK_F2), spawn "i3lock -uc 000000")

	, ((altm, xK_F3), spawn "xrandr --output HDMI2 --off --output eDP1 --auto")
	, ((altm, xK_F4), spawn "xrandr --output HDMI2 --auto --output eDP1 --off")

	, ((altm, xK_bracketleft), spawn "xbacklight -dec 10")
	, ((altm, xK_bracketright), spawn "xbacklight -inc 10")
	, ((altm, xK_minus), spawn "xbacklight -dec 100")
	, ((altm, xK_equal), spawn "xbacklight -inc 100")

	, ((altm, xK_e), spawn $ terminal_ ++ " -title urxvt")
	, ((altm, xK_r), spawn "qutebrowser")
	, ((altm, xK_d), spawn $ term "irssi -c localhost")
	, ((altm, xK_z), spawn $ term "ncmpcpp")
	, ((altm, xK_x), spawn $ term "neomutt")
	, ((altm, xK_c), spawn $ term "pulsemixer")
	, ((altm, xK_o), restart "/home/cptj/.xmonad/obx.sh" True)

	, ((altm, xK_a), spawn "maim -s screenshot$(date +'%Y-%m-%d_%H:%M:%S').png")

	, ((altm, xK_comma), spawn "ponymix toggle")
	, ((altm, xK_period), spawn "mpc toggle")
	, ((altm, xK_f), spawn $ message "echo $(mpc status | head -1) @ $(mpc status | awk 'NR==2 { print $3 }')" 3)
	, ((altm, xK_g), spawn "mpc listall music | sort --random-sort | head -20 | mpc add")
	, ((altm .|. shim, xK_comma), spawn $ message "mpc prev | head -1" 3)
	, ((altm .|. shim, xK_period), spawn $ message "mpc next | head -1" 3)
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

message :: String -> Int -> String
message s n = s ++ " > " ++ messageFile ++ " && sleep " ++ (show n) ++ " && echo > " ++ messageFile

altm = mod1Mask
supm = mod4Mask
shim = shiftMask

shifts_ = (composeAll
	[ --className =? "Firefox"      --> doShift "2"
	 title     =? "qutebrowser"  --> doShift "1"
--	, title     =? "urxvt"        --> doShift "1"
--	, roleName  =? "buddy_list"   --> doShift "4"
--	, roleName  =? "conversation" --> doShift "4"
	, title     =? "ncmpcpp"      --> doShift "10"
	, title     =? "pulsemixer"   --> doShift "10"
	, title     =? "neomutt"         --> doShift "10"
	])

roleName = stringProperty "WM_WINDOW_ROLE"

messageFile = "~/.xmonad/message"

--TODO newsbeuter


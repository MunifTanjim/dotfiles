-- Need to run the following command for Hammerspoon to use this config file
-- $ defaults write org.hammerspoon.hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

local utils = require("utils")

utils.ensure_spoon_installer()

spoon.SpoonInstall.use_syncinstall = true

spoon.SpoonInstall:andUse("EmmyLua")

hs.window.animationDuration = 0

local modifier = {
  blank = "",
  cmd = { "cmd" },
  cmd_shift = { "cmd", "shift" },
  cmd_alt = { "cmd", "alt" },
  cmd_alt_shift = { "cmd", "alt", "shift" },
  ctrl = { "ctrl" },
  ctrl_shift = { "ctrl", "shift" },
}

local wm = require("window-manager")
-- wm.logger.setLogLevel('debug')
wm:set_grid(6, 6):set_margins(hs.geometry.point(0, 0))
wm:bindHotkeys({
  up = { modifier.cmd_alt, "up" },
  right = { modifier.cmd_alt, "right" },
  down = { modifier.cmd_alt, "down" },
  left = { modifier.cmd_alt, "left" },
  center = { modifier.cmd_alt, "c" },
  switch_screen = { modifier.cmd_alt, "z" },
})

local config_loader = require("config-loader")
-- config_loader.logger.setLogLevel('debug')
config_loader:start()
config_loader:bindHotkeys({
  reload = { modifier.cmd_alt_shift, "r" },
})

-- MPD, MPC, MPDSCRIBBLE, NCMPCPP
hs.hotkey.bind(modifier.cmd_alt, "m", function()
  os.execute("~/.local/bin/music-terminal")
end)
hs.hotkey.bind(modifier.cmd_alt, ",", function()
  os.execute("/usr/local/bin/mpc prev")
end)
hs.hotkey.bind(modifier.cmd_alt, ".", function()
  os.execute("/usr/local/bin/mpc next")
end)

-- Screenshot (f13 = print_screen)
hs.hotkey.bind(modifier.blank, "f13", function()
  hs.application.open("com.apple.screenshot.launcher")
end)

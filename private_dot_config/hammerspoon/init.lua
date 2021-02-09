-- Need to run the following command for Hammerspoon to use this config file
-- $ defaults write org.hammerspoon.hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

local modifier = {
  cmd = {"cmd"},
  cmd_shift = {"cmd", "shift"},
  cmd_alt = {"cmd", "alt"},
  cmd_alt_shift = {"cmd", "alt", "shift"},
  ctrl = {"ctrl"},
  ctrl_shift = {"ctrl", "shift"},
}

hs.window.animationDuration = 0

wm = require("window-manager")
wm:set_grid(6, 6):set_margins(hs.geometry.point(0, 0))
wm:bindHotkeys({
  up         = {modifier.cmd_alt, "up"},
  right      = {modifier.cmd_alt, "right"},
  down       = {modifier.cmd_alt, "down"},
  left       = {modifier.cmd_alt, "left"},
  center     = {modifier.cmd_alt, "c"},
})

config_loader = require("config-loader")
config_loader:start()
config_loader:bindHotkeys({
  reload = {modifier.cmd_alt_shift, "r"}
})

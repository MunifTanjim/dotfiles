local mod = {}
mod.__index = mod

mod.name = "ConfigLoader"
mod.version = "0.0.0"
mod.author = "Munif Tanjim"
mod.homepage = ""
mod.license = "MIT (https://opensource.org/licenses/MIT)"

mod.logger = hs.logger.new(mod.name)

function mod.reload()
  hs.notify.new({ title = "Hammerspoon", informativeText = "Reloading Config...", withdrawAfter = 1 }):send()
  hs.timer.doAfter(1, hs.reload)
end

local watcher = hs.pathwatcher.new(hs.configdir, function(paths)
  for _, path in ipairs(paths) do
    if path:sub(-4) == ".lua" then
      mod.reload()
      break
    end
  end
end)

function mod:bindHotkeys(mapping)
  local spec = {
    reload = mod.reload,
  }
  hs.spoons.bindHotkeysToSpec(spec, mapping)
  return self
end

function mod:start()
  self.logger.d("starting pathwatcher")
  watcher:start()
  return self
end

function mod:stop()
  self.logger.d("stopping pathwatcher")
  watcher:stop()
  return self
end

function mod:init()
  self.logger.i("Loading " .. self.name)
end

return mod

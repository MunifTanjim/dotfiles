local mod = {}

function mod.ensure_spoon_installer()
  local function exec(cmd, failure_message)
    local stdout, ok = hs.execute(cmd)
    if ok then
      return string.gsub(stdout, "\n*$", "")
    end
    error(failure_message)
  end

  local spoons_dir = hs.configdir .. "/Spoons"

  if not hs.fs.attributes(table.concat({ spoons_dir, "SpoonInstall.spoon" }, "/")) then
    local tmpdir = exec("mktemp -d -t hammerspoon-XXX", "failed to create temporary directory")

    local archive_filename = "SpoonInstall.spoon.zip"
    local archive_url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/" .. archive_filename
    local archive_path = table.concat({ tmpdir, archive_filename })

    local status, body = hs.http.get(archive_url)
    if status >= 400 then
      error("failed to download: " .. archive_url)
    end

    local file = assert(io.open(archive_path, "w"))
    file:write(body)
    file:close()

    exec(string.format("unzip -o %s -d %s 2>&1", archive_path, spoons_dir), "failed to extract: " .. archive_path)
    exec(string.format("rm -rf '%s'", tmpdir), "failed to cleanup: " .. tmpdir)

    print("successfully installed: SpoonInstall.spoon")
  end

  hs.loadSpoon("SpoonInstall")
end

return mod

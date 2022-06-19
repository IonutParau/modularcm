local compression = require "LibDeflate"
local json = require "json"

local function InstallFromLocal(f)
  local file, err = io.open(f, "rw")

  if file == nil then print("Error: " .. err) return false end

  local content = file:read("*a")

  local decompressed = compression:DecompressDeflate(content)

  local data = json.decode(decompressed)

  local name = data.name

  if not name then print("Unable to find package name") return false end

  os.execute("mkdir " .. JoinPath("packages", name))

  local files = data.files

  local outdirs = {}
  local outfiles = {}
  local out = {}

  for path, fileContent in pairs(files) do
    if fileContent == 1 then
      table.insert(outdirs, path)
    else
      table.insert(outfiles, path)
    end
  end

  for _, path in ipairs(outdirs) do
    table.insert(out, path)
  end

  for _, path in ipairs(outfiles) do
    table.insert(out, path)
  end

  for _, path in ipairs(out) do
    local fileContent = files[path]

    if fileContent == 1 then
      print("Creating directory " .. path .. "...")
      os.execute("mkdir " .. JoinPath("packages", name, unpack(SplitStr(path, "/"))))
    else
      print("Creating file " .. path .. "...")
      local p = JoinPath("packages", name, unpack(SplitStr(path, "/")))
      local thisFile, ferr = io.open(p, "w")
      if not thisFile then print("Failed to build file " .. path .. ": " .. ferr) return false end
      ---@diagnostic disable-next-line: need-check-nil
      thisFile:write(fileContent)
      ---@diagnostic disable-next-line: need-check-nil
      thisFile:close()
    end
  end

  file:close()
  return true
end

local function getpackagefiles(folder)
  local t = {}

  local files = ScanDir(folder)

  for _, file in pairs(files) do
    if IsDir(JoinPath(folder, file)) then
      table.insert(t, JoinPath(folder, file))
      local subfiles = getpackagefiles(JoinPath(folder, file))
      for _, subfile in pairs(subfiles) do
        table.insert(t, subfile)
      end
    else
      table.insert(t, JoinPath(folder, file))
    end
  end

  return t
end

local function Compile(package)
  local t = getpackagefiles(JoinPath("packages", package))
  local sep = IsWindows and "\\" or "/"

  local files = {}

  for _, file in ipairs(t) do
    print("Compiling " .. file .. "...")
    if IsDir(file) then
      local fileNameSplit = SplitStr(file, sep)
      table.remove(fileNameSplit, 1)
      table.remove(fileNameSplit, 1)
      local fileName = table.concat(fileNameSplit, "/")
      files[fileName] = 1
    else
      local fileContent = io.open(file, "r"):read("*a")
      local fileNameSplit = SplitStr(file, sep)
      table.remove(fileNameSplit, 1)
      table.remove(fileNameSplit, 1)
      local fileName = table.concat(fileNameSplit, "/")

      files[fileName] = fileContent
    end
  end

  local p = {
    files = files,
    name = package,
  }

  local compressed = compression:CompressDeflate(json.encode(p))

  print("Compiled package...")

  io.write("Please write the output file name > ")
  local name = io.read("l")

  local file, err = io.open(name, "w")
  if not file then
    print("Could not open file for writing. Reason: " .. err)
    return
  end
  file:write(compressed)
  file:close()
end

local function Mod(args)
  local action = args[1]

  if action == "add" then
    local f = args[2]
    local s = InstallFromLocal(f)
    if s then print("Successfully installed package from local file") else print("Failed to install package") end
  elseif action == "compile" then
    local package = args[2]
    print("Compiling...")
    Compile(package)
  elseif action == "list" then
    local packages = ScanDir("packages")
    for _, package in pairs(packages) do
      print(package)
    end
  elseif action == "help" then
    print("Usage: mod <action> [args]")
    print("Actions:")
    print("  add <file>")
    print("  compile <package>")
    print("  list")
  end
end

BindCommand("mod", Mod)

local commands = {}

local json = require "json"

---@type FixedGrid|DynamicGrid|nil
Grid = nil
---@type FixedGrid|DynamicGrid|nil
InitialGrid = nil

IsWindows = package.config:sub(1, 1) == '\\'

---@param t table
---@return table
function table.copy(t)
  local nt = {}

  for k, v in pairs(t) do
    if type(v) == "table" then
      nt[k] = table.copy(v)
    else
      nt[k] = v
    end
  end

  return nt
end

function ScanDir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile
  if IsWindows then
    pfile = popen('dir "' .. directory .. '" /b')
  else
    pfile = popen('ls -a "' .. directory .. '"')
  end
  for filename in pfile:lines() do
    if filename:sub(1, 1) ~= "." then
      i = i + 1
      t[i] = filename
    end
  end
  pfile:close()
  return t
end

function IsDir(path)
  local f = io.open(path)
  if not f then return true end
  return not f:read(0) and f:seek("end") ~= 0
end

---@param commandName string
---@param runner function
function BindCommand(commandName, runner)
  commands[commandName] = runner
end

BindCommand("exit", function() os.exit(0) end)

---@param cmd string
---@param args table
function Shell(cmd, args)
  if not cmd then return end
  local command = commands[cmd]
  if command then
    command(args)
  else
    print("Unknown command: " .. cmd)
  end
end

---@param str string
---@param s string
function SplitStr(str, s)
  local sep, fields = s or " ", {}
  local pattern = string.format("([^%s]+)", sep)
  local _, _ = str:gsub(pattern, function(c) fields[#fields + 1] = c end)
  return fields
end

function ParseCommand(str)
  local cmd = SplitStr(str, " ")

  local cmdname = cmd[1]
  local args = {}
  for i = 2, #cmd do
    args[i - 1] = cmd[i]
  end

  return cmdname, args
end

function RunCmd(str)
  local cmdname, args = ParseCommand(str)
  Shell(cmdname, args)
end

local _queues = {}

function CreateQueue(queue)
  if not _queues[queue] then _queues[queue] = {} end
end

function RunQueue(queue, ...)
  local q = _queues[queue] or {}

  while #q > 0 do
    local f = q[1]
    table.remove(q, 1)
    f(...)
  end
end

function Queue(queue, func)
  if not _queues[queue] then CreateQueue(queue) end
  table.insert(_queues[queue], func)
end

CreateQueue "init"
CreateQueue "pre-cmd"
CreateQueue "post-cmd"

local canShell = true

BindCommand("close-shell", function() canShell = false end)

function ToggleShell()
  canShell = not canShell
end

function CanShell() return canShell end

function JoinPath(...)
  local str = ""

  local t = { ... }

  local sep = "/"
  if IsWindows then sep = "\\" end

  return table.concat(t, sep)
end

ModularCM = {}
ModularCM.version = "0.0.1 beta"

local packages = ScanDir "packages"
ModularCM.packages = packages

function ModularCM.getPackages()
  ModularCM.packages = ScanDir("packages")
  return ModularCM.packages
end

require "src.cell"
require "src.grid"
require "src.movement.push"
require "src.callback"
require "src.update"
require "src.saving"
require "src.shell"

local depended = {}
function Depend(...)
  local t = { ... }
  for _, p in ipairs(t) do
    if not depended[p] then
      print("Loaded package " .. p)
      depended[p] = true
      require("packages." .. p .. ".init")
    end
  end
end

BindCommand("load", function(args)
  Depend(args[1])
end)

for _, package in ipairs(packages) do
  Depend(package)
end

RunQueue "init"

while canShell do
  RunQueue("pre-cmd")
  local l = ModularCM.shell()
  RunQueue("post-cmd", l)
end

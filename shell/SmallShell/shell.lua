SmallShell = {}

--See https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line/38617204#38617204 for a list of color codes
SmallShell.settings = {
  pointerColor = 96,
  pointerText = ">",
  commandColor = 92,
  textColor = 93,
}

SmallShell.cheatsheet = {
  reset = 0,
  bold = 1,
  underline = 4,
  inverse = 7,
  black = 30,
  red = 31,
  green = 32,
  yellow = 33,
  blue = 34,
  magenta = 35,
  cyan = 36,
  white = 37,
  brightBlack = 90,
  brightRed = 91,
  brightGreen = 92,
  brightYellow = 93,
  brightBlue = 94,
  brightMagenta = 95,
  brightCyan = 96,
  brightWhite = 97,
  backgroundBlack = 40,
  backgroundRed = 41,
  backgroundGreen = 42,
  backgroundYellow = 43,
  backgroundBlue = 44,
  backgroundMagenta = 45,
  backgroundCyan = 46,
  backgroundWhite = 47,
  backgroundBrightBlack = 100,
  backgroundBrightRed = 101,
  backgroundBrightGreen = 102,
  backgroundBrightYellow = 103,
  backgroundBrightBlue = 104,
  backgroundBrightMagenta = 105,
  backgroundBrightCyan = 106,
  backgroundBrightWhite = 107,
}

for k, v in pairs(SmallShell.cheatsheet) do
  SmallShell.cheatsheet[v] = k
end

function SmallShell.shellFunc()
  io.write("\27[" ..
    tostring(SmallShell.settings.pointerColor) ..
    "m" .. SmallShell.settings.pointerText .. "\27[0m \27[" .. tostring(SmallShell.settings.commandColor) .. "m")
  local line = io.read()
  io.write("\27[" .. SmallShell.settings.textColor .. "m")
  RunCmd(line)
  return line
end

BindCommand("set-shell-pointer", function(args)
  if not args[1] then return end
  SmallShell.settings.pointerText = table.concat(args, " ")
end)

BindCommand("set-shell-pointer-color", function(args)
  if not args[1] then return end
  SmallShell.settings.pointerColor = table.concat(args, " ")
end)

BindCommand("set-shell-command-color", function(args)
  if not args[1] then return end
  SmallShell.settings.commandColor = table.concat(args, " ")
end)

BindCommand("set-shell-text-color", function(args)
  if not args[1] then return end
  SmallShell.settings.textColor = table.concat(args, " ")
end)

return SmallShell.shellFunc

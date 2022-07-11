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
  [0] = "reset",
  bold = 1,
  [1] = "bold",
  underline = 4,
  [4] = "underline",
  inverse = 7,
  [7] = "inverse",
  black = 30,
  [30] = "black",
  red = 31,
  [31] = "red",
  green = 32,
  [32] = "green",
  yellow = 33,
  [33] = "yellow",
  blue = 34,
  [34] = "blue",
  magenta = 35,
  [35] = "magenta",
  cyan = 36,
  [36] = "cyan",
  white = 37,
  [37] = "white",
  brightBlack = 90,
  [90] = "brightBlack",
  brightRed = 91,
  [91] = "brightRed",
  brightGreen = 92,
  [92] = "brightGreen",
  brightYellow = 93,
  [93] = "brightYellow",
  brightBlue = 94,
  [94] = "brightBlue",
  brightMagenta = 95,
  [95] = "brightMagenta",
  brightCyan = 96,
  [96] = "brightCyan",
  brightWhite = 97,
  [97] = "brightWhite",
  backgroundBlack = 40,
  [40] = "backgroundBlack",
  backgroundRed = 41,
  [41] = "backgroundRed",
  backgroundGreen = 42,
  [42] = "backgroundGreen",
  backgroundYellow = 43,
  [43] = "backgroundYellow",
  backgroundBlue = 44,
  [44] = "backgroundBlue",
  backgroundMagenta = 45,
  [45] = "backgroundMagenta",
  backgroundCyan = 46,
  [46] = "backgroundCyan",
  backgroundWhite = 47,
  [47] = "backgroundWhite",
  backgroundBrightBlack = 100,
  [100] = "backgroundBrightBlack",
  backgroundBrightRed = 101,
  [101] = "backgroundBrightRed",
  backgroundBrightGreen = 102,
  [102] = "backgroundBrightGreen",
  backgroundBrightYellow = 103,
  [103] = "backgroundBrightYellow",
  backgroundBrightBlue = 104,
  [104] = "backgroundBrightBlue",
  backgroundBrightMagenta = 105,
  [105] = "backgroundBrightMagenta",
  backgroundBrightCyan = 106,
  [106] = "backgroundBrightCyan",
  backgroundBrightWhite = 107,
  [107] = "backgroundBrightWhite",
}

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
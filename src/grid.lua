---@alias GridAlignment 0|1|2|3

require "src.fixed_grid"
require "src.dynamic_grid"

BindCommand("set-initial-grid", function()
  if not Grid then return print("No grid found.") end
  InitialGrid = Grid:copy()
  print("Set initial grid to copy of the current grid.")
end)

BindCommand("restore-initial-grid", function()
  if not InitialGrid then return print("No initial grid found.") end
  Grid = InitialGrid:copy()
  print("Set grid to copy of the current initial grid.")
end)

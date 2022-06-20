local subticks = {}

---@param subtick function
function AddSubtick(subtick, index)
  if type(index) == "number" then
    table.insert(subticks, index, subtick)
  else
    table.insert(subticks, subtick)
  end
end

NewCallback "cell-reset"

function UpdateGrid()
  Grid:loopGrid(function(x, y)
    local c = Grid:get(x, y)
    c.updated = false
    RunCallback("cell-reset", c, x, y)
  end, 0)
  for _, subtick in ipairs(subticks) do
    subtick(Grid)
  end
end

BindCommand("update", UpdateGrid)

local subticks = {}

---@param subtick function
function AddSubtick(subtick)
  table.insert(subticks, subtick)
end

function UpdateGrid()
  Grid:loopGrid(function(x, y)
    local c = Grid:get(x, y)
    c.updated = false
  end, 0)
  for _, subtick in ipairs(subticks) do
    subtick(Grid)
  end
end

BindCommand("update", UpdateGrid)

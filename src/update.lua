local subticks = {}

---@param subtick function
function AddSubtick(subtick)
  table.insert(subticks, subtick)
end

function UpdateGrid()
  for _, subtick in ipairs(subticks) do
    subtick(Grid)
  end
end

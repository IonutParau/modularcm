---@param grid FixedGrid|DynamicGrid
---@param str string
-- Based on the V1 decoder in https://github.com/TestAccountAaa/Cell-Machine-Mystic-Mod/blob/master/Assets/Assets/Scripts/LoadString.cs
return function(grid, str)
  local segs = SplitStr(str, ';')
  table.remove(segs, 1) -- Remove header



  local width = tonumber(segs[1])
  local height = tonumber(segs[2])

  local placementCellLocationsStr = SplitStr(segs[3], ',')
  if placementCellLocationsStr[1] ~= "" then
    for _, s in ipairs(placementCellLocationsStr) do
      local ssplit = SplitStr(s, '.')
      local x = tonumber(ssplit[1])
      local y = tonumber(ssplit[2])
      grid:setBackground(x, y, Cell("place", 0, {}))
    end
  end

  local cellStr = SplitStr(segs[4], ',')
  if cellStr[1] ~= "" then
    for _, s in ipairs(cellStr) do
      local split = SplitStr(s, '.')
      local x = tonumber(split[2])
      local y = tonumber(split[3])
      local id = VX.cells[tonumber(split[1])]
      local rot = tonumber(split[4])

      grid:set(x, y, Cell(id, rot, {}))
    end
  end
end

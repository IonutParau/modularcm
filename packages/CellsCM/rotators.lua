function RotateRaw(cell, amount)
  cell.rot = (cell.rot + amount) % 4
end

function RotateCell(x, y, amount, dir)
  local cell = Grid:get(x, y)
  if not cell then return end
  local config = GetCellConfig(cell.id)
  if type(config.canRotate) == "function" then
    if not config.canRotate(cell, amount, dir) then return end
  end
  RotateRaw(cell, amount)
end

function RotateAdjacents(x, y, amount)
  RotateCell(x + 1, y, amount)
  RotateCell(x - 1, y, amount)
  RotateCell(x, y + 1, amount)
  RotateCell(x, y - 1, amount)
end

Queue("init", function()
  CreateCell("rotatorCW", {})
  CreateCell("rotatorCCW", {})

  ---@param grid FixedGrid|DynamicGrid
  AddSubtick(function(grid)
    grid:loopGrid(function(x, y)
      local c = grid:get(x, y)
      if not c then return end
      if c.id == "rotatorCW" then
        RotateAdjacents(x, y, 1)
      elseif c.id == "rotatorCCW" then
        RotateAdjacents(x, y, -1)
      end
    end, 0)
  end)
end)

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

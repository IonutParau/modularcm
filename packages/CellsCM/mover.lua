local rotOrder = { 0, 2, 3, 1 }
Queue("init", function()
  CreateCell("mover", {
    forceProcessor = function(cell, x, y, dir, force, options)
      if dir == cell.rot then cell.updated = true return force + 1 end
      if dir == (cell.rot + 2) % 4 then return force - 1 end
      return force
    end,
    generateInto = function(cell, x, y, dir)
      if dir == cell.rot then
        cell.updated = true
      end
      return cell
    end,
  })

  for _, rot in ipairs(rotOrder) do
    ---@param grid DynamicGrid|FixedGrid
    AddSubtick(function(grid)
      grid:loopGrid(function(x, y)
        local c = grid:get(x, y)
        if not c then return end
        if c.id == "mover" and c.rot == rot and not c.updated then
          Push(x, y, rot, 0, {})
        end
      end, rot)
    end)
  end
end)

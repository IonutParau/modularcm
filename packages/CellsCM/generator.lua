local rotOrder = { 0, 2, 3, 1 }

---@param cell Cell
---@param x number
---@param y number
---@param rot number
-- Transforms a cell into what it should be generated as. By default it is turned into itself (big surprise!). It also can be turned into a different cell. Influenced by generateInto. Return nil to cancel the generation attempt.
function ToGenerate(cell, x, y, rot)
  if cell.id == "empty" then return nil end

  local conf = GetCellConfig(cell.id)

  if type(conf.generateInto) == "function" then
    return conf.generateInto(table.copy(cell), x, y, rot)
  end

  return cell
end

---@param x number
---@param y number
---@param rot number
function DoGen(x, y, rot)
  local bx, by = Grid:indir(x, y, rot, -1)
  local fx, fy = Grid:indir(x, y, rot, 1)

  local bcell = ToGenerate(Grid:at(bx, by), bx, by, rot)

  if bcell == nil then return end

  Push(fx, fy, rot, 1, { replacecell = bcell })
end

Queue("init", function()
  CreateCell("generator", {
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
        if c.id == "generator" and c.rot == rot and not c.updated then
          DoGen(x, y, rot)
        end
      end, rot)
    end)
  end
end)
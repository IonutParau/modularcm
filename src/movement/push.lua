function ProcessPush(cell, x, y, force, options)
  local config = GetCellConfig(cell.id)

  local newforce = force

  if type(config.forceProcessor) == "function" then
    newforce = config.forceProcessor(cell, x, y, force, options)
  end

  local shoulddestroy = false

  if type(config.shouldDestroyOnMove) == "function" then
    shoulddestroy = config.shouldDestroyOnMove(cell, x, y, force, options)
  end

  return newforce, shoulddestroy
end

---@return boolean, boolean
function Push(x, y, dir, force, options)
  if not Grid:inside(x, y) then return false, false end

  local cell = Grid:at(x, y)
  if cell.id == "empty" then return true, false end
  local newforce, shoulddestroy = ProcessPush(cell, x, y, force, options)

  if newforce > 0 and not shoulddestroy then
    local fx, fy = Grid:indir(x, y, dir, 1)
    local canmove, die = Push(fx, fy, dir, newforce, options)

    if die then Grid:set(x, y, Cell("empty", 0, {})) end

    if canmove and not die then
      Grid:set(x, y, Cell("empty", 0, {}))
      Grid:set(fx, fy, cell)
    end

    return canmove, false
  end

  return newforce > 0, shoulddestroy
end

function ProcessPush(cell, x, y, dir, force, options)
  local config = GetCellConfig(cell.id)

  local newforce = force

  if type(config.forceProcessor) == "function" then
    newforce = config.forceProcessor(cell, x, y, dir, force, options)
    if newforce == true then newforce = force end
    if newforce == false then newforce = 0 end
  end

  local shoulddestroy = false

  if type(config.shouldDestroyOnMove) == "function" then
    shoulddestroy = config.shouldDestroyOnMove(cell, x, y, dir, force, options)
  end

  return newforce, shoulddestroy
end

---@return boolean, boolean
function Push(x, y, dir, force, options)
  options = options or {}


  if not Grid:inside(x, y) then return false, false end

  options.forcetype = "push"
  options.replacecell = options.replacecell or Cell("empty", 0, {})
  options.depth = options.depth or 0
  if options.depth > 8000 then return false, false end

  local cell = Grid:at(x, y)
  if cell.id == "empty" then
    Grid:set(x, y, table.copy(options.replacecell))
    return true, false
  end
  local newforce, shoulddestroy = ProcessPush(cell, x, y, dir, force, options)

  if newforce > 0 and not shoulddestroy then
    local fx, fy = Grid:indir(x, y, dir, 1)
    local nextoptions = table.copy(options)
    nextoptions.replacecell = cell
    nextoptions.depth = options.depth + 1
    local canmove, die = Push(fx, fy, dir, newforce, nextoptions)

    if die then Grid:set(x, y, options.replacecell) return true, false end

    if canmove and not die then
      Grid:set(x, y, options.replacecell)
    end

    return canmove, false
  end

  return newforce > 0, shoulddestroy
end

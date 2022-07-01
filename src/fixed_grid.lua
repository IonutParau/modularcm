---@class FixedGrid
---@field cells table
---@field bg table
---@field width number
---@field height number
---@field type string
local _FixedGrid = {}
_FixedGrid.__index = _FixedGrid

function _FixedGrid:create()
  self.cells = {}
  for x = 1, self.width do
    self.cells[x] = {}
    for y = 1, self.height do
      self.cells[x][y] = Cell("empty", 0, {})
    end
  end
  self.bg = {}
  for x = 1, self.width do
    self.bg[x] = {}
    for y = 1, self.height do
      self.bg[x][y] = Cell("empty", 0, {})
    end
  end
end

function _FixedGrid:indir(x, y, dir, amount)
  amount = amount or 1

  if dir == 0 then return x + amount, y end
  if dir == 1 then return x, y + amount end
  if dir == 2 then return x - amount, y end
  if dir == 3 then return x, y - amount end
end

---@param callback function
---@param alignment GridAlignment
function _FixedGrid:loopGrid(callback, alignment)
  alignment = alignment or 2

  if alignment == 2 then
    for y = 1, self.height do
      for x = 1, self.width do
        callback(x, y)
      end
    end
  elseif alignment == 0 then
    for y = 1, self.height do
      for x = self.width, 1, -1 do
        callback(x, y)
      end
    end
  elseif alignment == 1 then
    for x = 1, self.width do
      for y = self.height, 1, -1 do
        callback(x, y)
      end
    end
  elseif alignment == 3 then
    for x = 1, self.width do
      for y = 1, self.height do
        callback(x, y)
      end
    end
  end
end

---@param x number
---@param y number
function _FixedGrid:inside(x, y)
  return (x > 0 and x <= self.width and y > 0 and y <= self.height)
end

---@param x number
---@param y number
---@param cell Cell
function _FixedGrid:set(x, y, cell)
  FixCell(cell, x, y)
  if self:inside(x, y) then
    self.cells[x][y] = cell
  end
end

---@param x number
---@param y number
function _FixedGrid:at(x, y)
  if not self:inside(x, y) then return FixCell(Cell("empty", 0, {}), x, y) end
  return FixCell(self.cells[x][y])
end

---@param x number
---@param y number
function _FixedGrid:get(x, y)
  if not self:inside(x, y) then return nil end
  return FixCell(self.cells[x][y])
end

---@param x number
---@param y number
function _FixedGrid:getBackground(x, y)
  if not self:inside(x, y) then return nil end
  return self.bg[x][y]
end

---@param x number
---@param y number
---@param cell Cell
function _FixedGrid:setBackground(x, y, cell)
  if not self:inside(x, y) then return end
  self.bg[x][y] = cell
end

function _FixedGrid:new(width, height)
  local c = setmetatable({
    width = width,
    height = height,
    cells = {},
    bg = {},
    type = "fixed",
  }, self)

  c:create()

  return c
end

function _FixedGrid:copy()
  local g = _FixedGrid:new(self.width, self.height)
  g.bg = table.copy(self.bg)
  g.cells = table.copy(self.cells)
end

---@param width number
---@param height number
function FixedGrid(width, height)
  return _FixedGrid:new(width, height)
end

BindCommand("create-fixed-grid", function(args)
  local width = tonumber(args[1])
  if not width then return print("Width is not a number") end
  local height = tonumber(args[2])
  if not height then return print("Height is not a number") end

  Grid = FixedGrid(width, height)
  print("Created a " .. width .. "x" .. height .. " grid.")
  InitialGrid = Grid:copy()
end)

local deflate = require "LibDeflate"
local json = require "json"

---@param cell Cell
---@param bg Cell
local function isSimpleCell(cell, bg)
  return ((next(cell.data) ~= nil) and next(bg.data) ~= nil)
end

---@param cell Cell
---@param bg Cell
---@param x number
---@param y number
---@param gridType string
local function encodeCell(cell, bg, x, y, gridType)
  if gridType == "fixed" then
    if isSimpleCell(cell, bg) then
      return tostring(cell.id .. tostring(cell.rot) .. "|" .. bg.id .. tostring(bg.rot))
    else
      return { cell.id, cell.rot, cell.data, bg.id, bg.rot, bg.data }
    end
  elseif gridType == "dynamic" then
    if isSimpleCell(cell, bg) then
      return tostring(tostring(x) ..
        "." .. tostring(y) .. ":" .. cell.id .. tostring(cell.rot) .. "|" .. bg.id .. tostring(bg.rot))
    else
      return { x, y, cell.id, cell.rot, cell.data, bg.id, bg.rot, bg.data }
    end
  end
end

---@param grid FixedGrid|DynamicGrid
local function encode(grid)
  local gridData = {
    GT = grid.type,
  }

  ---@type table|string
  local cellData = {}
  local allSimple = true

  grid:loopGrid(function(x, y)
    local cell = grid:get(x, y)
    local bg = grid:getBackground(x, y)
    ---@diagnostic disable-next-line: param-type-mismatch
    if not isSimpleCell(cell, bg) then allSimple = false end
    ---@diagnostic disable-next-line: param-type-mismatch
    table.insert(cellData, encodeCell(cell, bg, x, y, grid.type))
  end, 2)

  if allSimple then
    ---@diagnostic disable-next-line: param-type-mismatch
    cellData = table.concat(cellData, ",")
  end

  local str = "VX;;;"
  str = str .. deflate:EncodeForPrint(deflate:CompressDeflate(json.encode(cellData))) .. ";"
  str = str .. deflate:EncodeForPrint(deflate:CompressDeflate(json.encode(gridData))) .. ";"

  if grid.type == "fixed" then
    str = str .. tostring(grid.width) .. ";"
    str = str .. tostring(grid.height) .. ";"
  end

  return str
end

---@param str string
local function decode(str)
  ---@type FixedGrid|DynamicGrid
  local grid
end

return {
  encode = encode,
  decode = decode,
}

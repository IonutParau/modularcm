local deflate = require "LibDeflate"
local json = require "json"
require "base64"

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
      return tostring(cell.id) .. tostring(cell.rot) .. "|" .. bg.id .. tostring(bg.rot)
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

---@param encoded string|table
---@param gridType "fixed"|"dynamic"
---@return Cell|nil, Cell|nil, number|nil, number|nil
local function decodeCell(encoded, gridType)
  if gridType == "fixed" then
    if type(encoded) == "string" then
      local segments = SplitStr(encoded, '|')

      local seg1 = segments[1]
      local seg2 = segments[2]

      local cellID = seg1:sub(1, -2)
      local backID = seg2:sub(1, -2)

      local cellRot = tonumber(seg1:sub(#seg1, #seg1))
      local bgRot = tonumber(seg2:sub(#seg2, #seg2))

      if cellRot == nil then return end
      if bgRot == nil then return end

      return Cell(cellID, cellRot, {}), Cell(cellID, cellRot, {})
    elseif type(encoded) == "table" then
      ---@type Cell[]
      local cells = {}

      for i = 1, #encoded, 3 do
        ---@type string
        local id = encoded[i]
        ---@type number
        local rot = encoded[i + 1]
        ---@type table
        local data = encoded[i + 2]

        table.insert(cells, Cell(id, rot, data))
      end

      return cells[1], cells[2]
    end
  elseif gridType == "dynamic" then
    if type(encoded) == "string" then
      local posAndData = SplitStr(encoded, ":")
      local posParts = SplitStr(encoded, '.')
      local x = tonumber(posParts[1]) or 0
      local y = tonumber(posParts[2]) or 0

      local data = SplitStr(encoded, '|')

      ---@type Cell[]
      local cells = {}

      for i = 1, #data, 2 do
        local id = data[i]
        local rot = tonumber(data[i + 1])
      end

      return cells[1], cells[2]
    elseif type(encoded) == "table" then
      ---@type number
      local x = encoded[1]
      ---@type number
      local y = encoded[2]

      ---@type Cell[]
      local cells = {}

      for i = 3, #encoded, 3 do
        ---@type string
        local id = encoded[i]

        ---@type number
        local rot = encoded[i + 1]

        ---@type table
        local data = encoded[i + 2]

        table.insert(cells, Cell(id, rot, data))
      end

      return cells[1], cells[2], x, y
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
  str = str .. to_base64(deflate:CompressDeflate(json.encode(cellData))) .. ";"
  str = str .. to_base64(deflate:CompressDeflate(json.encode(gridData))) .. ";"

  if grid.type == "fixed" then
    str = str .. tostring(grid.width) .. ";"
    str = str .. tostring(grid.height) .. ";"
  end

  return str
end

---@param str string
---@return FixedGrid|DynamicGrid
local function decode(str)

  ---@type FixedGrid|DynamicGrid
  local grid


  local parts = SplitStr(str, ';')
  local title = parts[2]
  local desc = parts[3]
  local cellData = json.decode(deflate:DecompressDeflate(from_base64(parts[4])))
  local gridData = json.decode(deflate:DecompressDeflate(from_base64(parts[5])))

  local width
  local height

  if gridData.GT == "fixed" then
    width = tonumber(parts[6]) or 0
    height = tonumber(parts[7]) or 0
    grid = FixedGrid(width, height)
  elseif gridData.GT == "dynamic" then
    grid = DynamicGrid()
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  local cellDataArr = (type(cellData) == "table") and cellData or SplitStr(cellData, ",")

  if gridData.GT == "fixed" then
    local i = 0
    grid:loopGrid(function(x, y)
      i = i + 1

      local cell, bg = decodeCell(cellDataArr[i], gridData.GT)

      if cell == nil then return end
      if bg == nil then return end

      grid:set(x, y, cell)
      grid:setBackground(x, y, bg)
    end, 2)
  elseif gridData.GT == "dynamic" then
    for i = 1, #cellDataArr do
      local cell, bg, x, y = decodeCell(cellDataArr[i], gridData.GT)

      if x == nil or y == nil or cell == nil or bg == nil then
        return grid
      end

      grid:set(x, y, cell)
      grid:setBackground(x, y, bg)
    end
  end

  return grid
end

return {
  encode = encode,
  decode = decode,
}

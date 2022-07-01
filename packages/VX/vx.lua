local deflate = require "LibDeflate"

--Implementation of The Puzzle Cell Markup Language (TPCML) implemented in Lua.
VX.TPCML = {}

---@param str string
---@param sep string
---@return table
function VX.TPCML.split(str, sep)
  local t = { "" }

  local bias = 0

  for i = 1, #str do
    local c = str:sub(i, i)

    local changedbias = false

    if c == "(" then
      bias = bias + 1
      changedbias = true
    elseif c == ")" then
      bias = bias - 1
      changedbias = true
    end

    if (bias == 0) and (not changedbias) and (c == sep) then
      table.insert(t, "")
    else
      t[#t] = t[#t] .. c
    end
  end

  return t
end

---@param v table|string|boolean|number|nil
---@return string
--Encoder of the markup language
function VX.TPCML.encode(v)
  if type(v) == "string" then
    return v
  elseif type(v) == "nil" then
    return ""
  elseif (type(v) == "boolean") or (type(v) == "number") then
    return tostring(v)
  elseif type(v) == "table" then
    local outputs = {}
    local visited = {}

    for i, val in ipairs(v) do
      visited[i] = true
      table.insert(outputs, VX.TPCML.encode(val))
    end

    for key, value in pairs(v) do
      if not visited[key] then
        table.insert(outputs, VX.TPCML.encode(key) .. "=" .. VX.TPCML.encode(value))
      end
    end

    return "(" .. table.concat(outputs, ":") .. ")"
  end

  return v
end

---@param str string
---@return table|string|boolean|number|nil
--Decoder of the markup language
function VX.TPCML.decode(str)
  if tonumber(str) ~= nil then return tonumber(str) end
  if str == "true" or str == "false" then return str == "true" end
  if str == "" then return nil end

  if str:sub(1, 1) == "(" and str:sub(#str, #str) == ")" then
    local kvp = VX.TPCML.split(str:sub(2, #str - 1), ":")
    local t = {}

    for _, kv in ipairs(kvp) do
      local k, v = unpack(VX.TPCML.split(kv, "="))
      t[VX.TPCML.decode(k)] = VX.TPCML.decode(v)
    end

    return t
  end

  return str
end

---@param grid FixedGrid|DynamicGrid
---@return string
local function _encode(grid)
  local str = "VX:"

  local props = {}

  props["T"] = (grid.type or "U")
  if grid.width then props["W"] = grid.width end
  if grid.height then props["H"] = grid.height end
  if grid.bg then props["B"] = VX.TPCML.encode(grid.bg) end
  if grid.cells then props["C"] = VX.TPCML.encode(grid.cells) end

  local propsStr = VX.TPCML.encode(props)

  local compressedPropsStr = deflate:CompressDeflate(propsStr)

  local printablePropsStr = deflate:EncodeForPrint(compressedPropsStr)

  str = str .. printablePropsStr .. ":"

  return str
end

---@param str string
---@return FixedGrid|DynamicGrid
local function _decode(str)

end

return {
  encode = _encode,
  decode = _decode,
}

local callbacks = {}

function NewCallback(name)
  if not callbacks[name] then callbacks[name] = {} end
end

function RunCallback(name, ...)
  local t = callbacks[name] or {}

  for _, callback in ipairs(t) do
    callback(...)
  end
end

function Callback(name, callback)
  NewCallback(name)
  table.insert(callbacks[name], callback)
end

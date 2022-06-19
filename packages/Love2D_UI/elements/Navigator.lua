---@class UI.Navigator
---@field p string
---@field paths table
UINavigator = {}
UINavigator.__index = UINavigator

---@return UI.Navigator
---@param defaultPath string
---@param paths table
function UINavigator:new(defaultPath, paths)
  return setmetatable({p = defaultPath or "/", paths = paths}, self)
end

function UINavigator:Navigate(newPath)
  self.p = newPath
end

function UINavigator:render()
  self.paths[self.p]:render()
end

function UINavigator:click(x, y)
  self.paths[self.p]:click(x, y)
end

function UINavigator:update(dt)
  self.paths[self.p]:update(dt)
end

function UINavigator:typec(c)
  self.paths[self.p]:typec(c)
end

function UINavigator:listen(event, ...)
  self.paths[self.p]:listen(event, ...)
end
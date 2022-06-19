---@class UI.Container
---@field children table
UIContainer = {}
UIContainer.__index = UIContainer

---@return UI.Container
function UIContainer:new()
  return setmetatable({children = {}}, self)
end

function UIContainer:click(x, y)
  for _, child in ipairs(self.children) do
    if child.click then
      child:click(x, y)
    end
  end
end

function UIContainer:update(dt)
  for _, child in ipairs(self.children) do
    if child.update then
      child:update(dt)
    end
  end
end

function UIContainer:render()
  for _, child in ipairs(self.children) do
    if child.render then
      child:render()
    end
  end
end

function UIContainer:typec(t)
  for _, child in ipairs(self.children) do
    if child.typec then
      child:typec(t)
    end
  end
end

function UIContainer:listen(event, ...)
  for _, child in ipairs(self.children) do
    if child.listen then
      child:listen(event, ...)
    end
  end
end

function UIContainer:insert(child)
  table.insert(self.children, child)
end

function UIContainer:insertAll(children)
  for _, child in ipairs(children) do
    self:insert(child)
  end
end
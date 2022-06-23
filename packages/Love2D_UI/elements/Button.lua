---@class UI.Button
---@field x number
---@field y number
---@field w number
---@field h number
---@field callback function
---@field image string
---@field alignment UI.Alignment
UIButton = {}
UIButton.__index = UIButton

---@return UI.Button
---@param x number
---@param y number
---@param w number
---@param h number
---@param click function
---@param alignment UI.Alignment
---@param image string
function UIButton:new(x, y, w, h, click, image, alignment)
  return setmetatable({
    x = x,
    y = y,
    w = w,
    h = h,
    callback = click,
    image = image,
    alignment = alignment,
  }, self)
end

function UIButton:render()
  local sx, sy = UIManager:processAlignment(self.alignment, self.x, self.y)
  local x, y = love.mouse.getX(), love.mouse.getY()
  if not (x > sx and y > sy and x < sx + self.w and y < sy + self.h) then
    love.graphics.setColor(1, 1, 1, 0.5)
  end
  love.graphics.draw(self.image, sx, sy, 0, self.w / self.image:getWidth(), self.h / self.image:getHeight())
  love.graphics.setColor(1, 1, 1, 1)
end

---@param x number
---@param y number
function UIButton:click(x, y)
  local sx, sy = UIManager:processAlignment(self.alignment, self.x, self.y)
  if x > sx and y > sy and x < sx + self.w and y < sy + self.h then
    self.callback()
  end
end
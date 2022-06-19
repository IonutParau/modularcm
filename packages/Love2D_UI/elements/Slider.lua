---@class UISlider
---@field x number
---@field y number
---@field width number
---@field height number
---@field value number
---@field minvalue number
---@field maxvalue number
---@field callback function
---@field align UI.Alignment
UISlider = {}
UISlider.__index = UISlider

function UISlider:new(x, y, width, height, value, minvalue, maxvalue, callback, align)
  return setmetatable({
    x = x,
    y = y,
    width = width,
    height = height,
    value = value,
    minvalue = minvalue,
    maxvalue = maxvalue,
    callback = callback,
    align = align or "topleft",
  }, self)
end

function UISlider:checkCollision(x, y)
  local sx, sy = UIManager:processAlignment(self.align, self.x, self.y)

  return (
      (x >= sx) and
          (y >= sy) and
          (x <= (sx + self.width)) and
          (y <= (sy + self.height))
      )
end

function UISlider:update(dt)
  local x, y = love.mouse.getPosition()
  local sx, sy = UIManager:processAlignment(self.align, self.x, self.y)
  if love.mouse.isDown(1) then
    if self:checkCollision(x, y) then
      local p = x - sx

      self.value = (self.maxvalue - self.minvalue) * p + self.minvalue

      local startX, endX = sx, sx+self.width
      local sliderX = math.max(0, math.min(1, (love.mouse.getX() - startX) / (endX - startX)))
    
      local startval, endval = self.minvalue,self.maxvalue
      local val = sliderX

      self.value = val
      
      self.callback(startval+(endval-startval)*sliderX,sliderX)
    end
  end
end

function UISlider:render()
  local sx, sy = UIManager:processAlignment(self.align, self.x, self.y)

  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.rectangle("fill", sx, sy, self.width, self.height)

  love.graphics.setColor(0.7, 0.7, 0.7)
  local x = (sx+(self.value*self.width))

  love.graphics.rectangle("fill", x-(self.height/2), sy, self.height, self.height)
end

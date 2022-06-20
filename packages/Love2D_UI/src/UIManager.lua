-- Require every element
require("packages.Love2D_UI.elements.Text")
require("packages.Love2D_UI.elements.Button")
require("packages.Love2D_UI.elements.Container")
require("packages.Love2D_UI.elements.Image")
require("packages.Love2D_UI.elements.Textbox")
require("packages.Love2D_UI.elements.Slider")

---@alias UI.Alignment "\"topleft\""|"\"topright\""|"\"bottomleft\""|"\"bottomright\""|"\"center\""|"\"topcenter\""|"\"leftcenter\""|"\"bottomcenter\""|"\"rightcenter\""

---@class UIManager
UIManager = {}

---@param alignment UI.Alignment
---@param x number
---@param y number
---@return number, number
function UIManager:processAlignment(alignment, x, y)
  if alignment == "topleft" then
    return x, y
  else
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if alignment == "topright" then
      return w - x, y
    elseif alignment == "bottomleft" then
      return x, h - y
    elseif alignment == "bottomright" then
      return w - x, h - y
    elseif alignment == "center" then
      return (w * 0.5) + x, (h * 0.5) + y
    elseif alignment == "topcenter" then
      return (w * 0.5) + x, y
    elseif alignment == "leftcenter" then
      return x, (h * 0.5) + y
    elseif alignment == "bottomcenter" then
      return (w * 0.5) + x, h - y
    elseif alignment == "rightcenter" then
      return w - x, (h * 0.5) + y
    end
  end
end

UIManager.fontCache = {}
UIManager.currentFont = ""

---@return love.Font
---@param font string
---@param size number
function UIManager:FontCache(font, size)
  if self.currentFont == (font .. " " .. size) then return love.graphics.setFont(self.fontCache[font .. " " .. size]) end
  if self.fontCache[font .. " " .. size] ~= nil then
    self.currentFont = (font .. " " .. size)
    return love.graphics.setFont(self.fontCache[font .. " " .. size])
  end
  self.currentFont = (font .. " " .. size)
  self.fontCache[font .. " " .. size] = love.graphics.newFont(font, size)
  love.graphics.setFont(love.graphics.newFont(font, size))
end

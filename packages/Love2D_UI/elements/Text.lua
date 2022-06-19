---@class UI.Text
---@field x number
---@field y number
---@field text string
---@field fontSize number
---@field alignment UI.Alignment
UIText = {}
UIText.__index = UIText

---@return UI.Text
---@param x number
---@param y number
---@param text string
---@param fontSize number
---@param alignment UI.Alignment
function UIText:new(x, y, text, alignment, fontSize)
  return setmetatable({
    x = x,
    y = y,
    text = text,
    fontSize = fontSize,
    alignment = alignment,
  }, self)
end

function UIText:render()
  UIManager:FontCache("packages/Love2D_UI/font.ttf", 13 * self.fontSize)

  local sx, sy = UIManager:processAlignment(self.alignment, self.x, self.y)

  love.graphics.print(self.text, sx, sy, 0)
end
---@class UI.Image
---@field x number
---@field y number
---@field w number
---@field h number
---@field img string
---@field alignment UI.Alignment
UIImage = {}
UIImage.__index = UIImage

---@param x number
---@param y number
---@param w number
---@param h number
---@param img string
---@param alignment UI.Alignment
---@return UI.Image
function UIImage:new(x, y, w, h, img, alignment)
  return setmetatable({
    x = x,
    y = y,
    w = w,
    h = h,
    img = img,
    alignment = alignment,
  }, UIImage)
end

function UIImage:render()
  local sx, sy = UIManager:processAlignment(self.alignment, self.x, self.y)

  love.graphics.draw(tex[self.img], sx, sy, 0, self.w / tex[self.img]:getWidth(), self.h / tex[self.img]:getHeight())
end
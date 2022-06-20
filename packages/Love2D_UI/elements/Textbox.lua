CurrentTextbox = nil

---@class UI.Textbox
---@field x number
---@field y number
---@field w number
---@field h number
---@field textsize number
---@field text string
---@field callback function
---@field alignment UI.Alignment
---@field numonly boolean
---@field maxlen number
---@field numlimit number
---@field placeholder string
UITextbox = {}
UITextbox.__index = UITextbox

---@return UI.Textbox
---@param x number
---@param y number
---@param w number
---@param h number
---@param click function
---@param textsize number
---@param numonly boolean
---@param maxlen number
---@param alignment UI.Alignment
---@param placeholder string
---@param numlimit number
function UITextbox:new(x, y, w, h, alignment, textsize, numonly, maxlen, numlimit, placeholder, click)
  if numonly == nil then numonly = false end
  return setmetatable({
    x = x,
    y = y,
    w = w,
    h = h,
    callback = click or function() return true end,
    alignment = alignment,
    textsize = textsize,
    numonly = numonly,
    text = nil,
    maxlen = maxlen,
    numlimit = numlimit,
    placeholder = placeholder,
  }, self)
end

function UITextbox:render()
  local sx, sy = UIManager:processAlignment(self.alignment, self.x, self.y)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.rectangle("fill",sx,sy,self.w,self.h)
  love.graphics.setColor(1,1,1,1)

  UIManager:FontCache("packages/Love2D_UI/font.ttf", 13 * self.textsize)
  local t = self:GetText(true)
  if CurrentTextbox == self then t = t .. "_" end
  love.graphics.print(t, sx, sy, 0)
end

function UITextbox:GetText(rendering)
  if (CurrentTextbox == self) and rendering then return self.text or "" end
  if self.numonly then return self.text or (self.placeholder or "0") end
  return (self.text or (self.placeholder or "Empty"))
end

---@param x number
---@param y number
function UITextbox:click(x, y)
  local sx, sy = UIManager:processAlignment(self.alignment, self.x, self.y)
  if x > sx and y > sy and x < sx + self.w and y < sy + self.h then
    if self.callback() then
      CurrentTextbox = self
    end
  end
end

---@param char string
function UITextbox:typec(char)
  if CurrentTextbox == self then
    self.text = self.text or ""
    if CurrentTextbox.text == "0" then CurrentTextbox.text = "" end
    local old = CurrentTextbox.text
    if char == "backspace" then
      local byteoffset = utf8.offset(CurrentTextbox.text, -1)

      if #CurrentTextbox.text == 1 then
        old = ""
      end

      if byteoffset then
        CurrentTextbox.text = string.sub(CurrentTextbox.text, 1, byteoffset - 1)
      end
    else
      CurrentTextbox.text = CurrentTextbox.text .. char
    end
    if self.numonly and (tonumber(CurrentTextbox.text) == nil) then
      if CurrentTextbox.text == "" then
        CurrentTextbox.text = nil
      else
        CurrentTextbox.text = old
      end
    end
    if string.len(CurrentTextbox:GetText()) > self.maxlen then
      CurrentTextbox.text = old
    end
    if CurrentTextbox.text == "" then
      CurrentTextbox.text = nil
    end
    if self.numonly and CurrentTextbox:GetText() ~= "" and type(tonumber(CurrentTextbox:GetText())) == "number" and tonumber(CurrentTextbox:GetText()) > self.numlimit then
      CurrentTextbox.text = tostring(self.numlimit)
    end
  end
end
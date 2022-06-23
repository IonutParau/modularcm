local function tablecopy(oldtable)
  local newtable = {}
  for k,v in pairs(oldtable) do
    if type(v) == "table" then
      v = tablecopy(v)
    end
    newtable[k] = v
  end
  return newtable
end

NewCallback("update")

TickDelay = 0.2

CurrentTime = 0

Paused = true

function love.update(dt)
  if GameScreen == "Grid" then
    CurrentTime = CurrentTime + dt
    while CurrentTime >= TickDelay do
      if not Paused then
        CurrentTime = CurrentTime - TickDelay
        RunCmd("update")
      else
        CurrentTime = TickDelay
        break
      end
    end
  elseif GameScreen == "Settings" then
    Settings:update(dt)
  end
  if GameScreen == "Grid" then
    local canmove = true
    for _,v in ipairs(MoveCam) do
      local c = v()
      if not c then canmove = false end
    end
    if canmove then
      if love.keyboard.isScancodeDown("w") then
        Cam.y = Cam.y + 7*60*dt
      end
      if love.keyboard.isScancodeDown("s") then
        Cam.y = Cam.y - 7*60*dt
      end
      if love.keyboard.isScancodeDown("a") then
        Cam.x = Cam.x + 7*60*dt
      end
      if love.keyboard.isScancodeDown("d") then
        Cam.x = Cam.x - 7*60*dt
      end
    end
    Cam:interpolate(dt)

    if love.mouse.isDown(1) and Placecells then
      local x, y = love.mouse.getPosition()
      local cx, cy = ToGrid(x, y)
      for xx = cx-math.floor(Placesize/2), cx+math.ceil(Placesize/2) do
        for yy = cy-math.floor(Placesize/2), cy+math.ceil(Placesize/2) do
          Grid:set(xx, yy, tablecopy(Selected))
        end
      end
    elseif love.mouse.isDown(2) and Placecells then
      local x, y = love.mouse.getPosition()
      local cx, cy = ToGrid(x, y)
      for xx = cx-math.floor(Placesize/2), cx+math.ceil(Placesize/2) do
        for yy = cy-math.floor(Placesize/2), cy+math.ceil(Placesize/2) do
          Grid:set(xx, yy, Cell("empty", 0, {}))
        end
      end
    end
  end
  RunCallback("update",dt)
end

function love.wheelmoved(x,y)
  if love.keyboard.isDown("lctrl") then
    Placesize = Placesize + y
    if Placesize < 0 then Placesize = 0 end
  else
    local change = 2^y
    Cam.zoom = Cam.zoom * change
    Cam.x = Cam.x - love.mouse.getX()
    Cam.y = Cam.y - love.mouse.getY()
    Cam.x = Cam.x * change
    Cam.y = Cam.y * change
    Cam.x = Cam.x + love.mouse.getX()
    Cam.y = Cam.y + love.mouse.getY()
  end
end
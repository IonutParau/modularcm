NewCallback("textinput")
NewCallback("keypressed")

NewCallback("mousepressed")
NewCallback("mousereleased")

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

function love.mousepressed(x,y,b)
  if GameScreen == "mainmenu" and b == 1 then
    MainMenu:click(x,y)
  elseif GameScreen == "SelectSize" and b == 1 then
    SelectSize:click(x,y)
  elseif GameScreen == "Settings" and b == 1 then
    Settings:click(x,y)
  elseif GameScreen == "Grid" then
    if CellEnv == "default" then
      if b == 1 then CellBarClick(x,y) end
    elseif CellEnvs[CellEnv] then
      CellEnvs[CellEnv].click(x,y,b)
    end
    Overlay:click(x,y)
  elseif GameScreen == "Grid" and b == 3 then
    local cx, cy = ToGrid(x, y)
    Selected.id = Grid:get(cx, cy).id
  end
  if CustomPages[GameScreen] then
    for k,v in pairs(CustomPages[GameScreen]) do
      v.click(x,y,b)
    end
  end
  RunCallback("mousepressed", x, y, b)
end

function love.textinput(t)
  if GameScreen == "SelectSize" then
    SelectSize:typec(t)
  end
  RunCallback("textinput", t)
end

function love.keypressed(key, scancode, isrepeat)
  local canhandle = true
  for _,v in ipairs(DetectKeys) do
    local c = v()
    if not c then canhandle = false end
  end
  if canhandle then
    if key == "backspace" and GameScreen == "SelectSize" then
      SelectSize:typec("backspace")
    elseif GameScreen == "Grid" and (not isrepeat) then
      if key == "e" then
        Selected.rot = (Selected.rot + 1)%4
      elseif key == "q" then
        Selected.rot = (Selected.rot - 1)%4
      elseif key == "f" then
        CurrentTime = 0
        RunCmd("update")
      elseif key == "space" then
        Paused = not Paused
      end
    end
  end
  RunCallback("keypressed", key, scancode, isrepeat)
end

function love.mousereleased(x,y,b)
  Placecells = true
  RunCallback("mousereleased", x, y, b)
end
function love.mousepressed(x,y,b)
  if GameScreen == "mainmenu" and b == 1 then
    MainMenu:click(x,y)
  elseif GameScreen == "SelectSize" and b == 1 then
    SelectSize:click(x,y)
  elseif GameScreen == "Grid" and b == 1 then
    CellBarClick(x,y)
    Overlay:click(x,y)
  end
end

function love.textinput(t)
  if GameScreen == "SelectSize" then
    SelectSize:typec(t)
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "backspace" and GameScreen == "SelectSize" then
    SelectSize:typec("backspace")
  elseif GameScreen == "Grid" and (not isrepeat) then
    if key == "e" then
      Selected.rot = (Selected.rot + 1)%4
    elseif key == "q" then
      Selected.rot = (Selected.rot - 1)%4
    end
  end
end

function love.mousereleased(x,y,b)
  Placecells = true
end
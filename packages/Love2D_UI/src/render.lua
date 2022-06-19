function love.draw()
  love.graphics.setColor(1,1,1,1)
  if GameScreen == "mainmenu" then
    MainMenu:render()
  elseif GameScreen == "SelectSize" then
    SelectSize:render()
  elseif GameScreen == "Grid" then
    RenderGrid()
    local cx,cy = ToGrid(love.mouse.getX(), love.mouse.getY())
    love.graphics.setColor(1,1,1,0.3)
    local stx,sty = ToGrid(0,0)
    local enx,eny = ToGrid(love.graphics.getWidth(),love.graphics.getHeight())
    if Grid.width ~= nil then
      if stx < 1 then stx = 1 end
      if sty < 1 then sty = 1 end
      if enx > Grid.width then enx = Grid.width end
      if eny > Grid.height then eny = Grid.height end
    end
    for xx = cx-math.floor(Placesize/2), cx+math.ceil(Placesize/2) do
      for yy = cy-math.floor(Placesize/2), cy+math.ceil(Placesize/2) do
        if xx >= stx and xx <= enx and yy >= sty and yy <= eny then
          local sx,sy = ToScreen(xx,yy)
          DrawCell(sx,sy,Cam.gzoom,Cam.gzoom,Selected)
        end
      end
    end
    love.graphics.setColor(1,1,1,1)
    RenderCellBar()
    Overlay:render()
  end
end
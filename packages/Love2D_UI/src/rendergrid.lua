local halfpi = math.pi / 2

function RenderGrid()
  if Grid.width ~= nil then
    local stx,sty = ToGrid(0,0)
    local enx,eny = ToGrid(love.graphics.getWidth(),love.graphics.getHeight())
    if stx < 1 then stx = 1 end
    if sty < 1 then sty = 1 end
    if enx > Grid.width then enx = Grid.width end
    if eny > Grid.height then eny = Grid.height end
    local cpos = {}
    for x = stx, enx do
      for y = sty, eny do
        local bg = Grid:getBackground(x,y)
        local c = Grid:get(x,y)
        local sx,sy = ToScreen(x,y)
        if bg ~= nil then
          if c and c.id ~= "empty" then
            if ((CurrentTime ~= 0 and CurrentTime ~= TickDelay) and c.lastvars and (c.lastvars[1] ~= x or c.lastvars[2] ~= y or c.lastvars[3] ~= c.rot)) or (not c.lastvars) then
              DrawBG(sx,sy, Cam.gzoom, Cam.gzoom, bg)
            end
          else
            DrawBG(sx,sy, Cam.gzoom, Cam.gzoom, bg)
          end
        end
        if c ~= nil and c.id ~= "empty" then
          cpos[#cpos+1] = {x,y,c}
        end
      end
    end
    for i = 1, #cpos do
      local x,y = cpos[i][1], cpos[i][2]
      local c = cpos[i][3]
      local sx,sy = ToScreen(x,y)
      if c ~= nil then
        if c.lastvars then
          local cx,cy = ToScreen(c.lastvars[1] or x,c.lastvars[2] or y)
          local crot = c.lastvars[3] or c.rot
          local lval = CurrentTime/TickDelay
          local lerpedr = Lerp(c.lastvars[3],c.lastvars[3]+((c.rot-c.lastvars[3]+2)%4-2),lval)
          DrawCell(Lerp(cx,sx,lval), Lerp(cy,sy,lval), Cam.gzoom, Cam.gzoom, c, lerpedr)
        else
          DrawCell(sx,sy, Cam.gzoom, Cam.gzoom, c)
        end
      end
    end
  else
    local stx,sty = ToGrid(0,0)
    local enx,eny = ToGrid(love.graphics.getWidth(),love.graphics.getHeight())
    local cpos = {}
    for x = stx, enx do
      for y = sty, eny do
        local bg = Grid:getBackground(x,y)
        local c = Grid:get(x,y)
        local sx,sy = ToScreen(x,y)
        if bg == nil then bg = Cell("empty", 0, {}) end
        if bg ~= nil then
          if c and c.id ~= "empty" then
            if (c.lastvars and (c.lastvars[1] ~= x or c.lastvars[2] ~= y or c.lastvars[3] ~= c.rot)) or (not c.lastvars) then
              DrawBG(sx,sy, Cam.gzoom, Cam.gzoom, bg)
            end
          else
            DrawBG(sx,sy, Cam.gzoom, Cam.gzoom, bg)
          end
        end
        if c ~= nil and c.id ~= "empty" then
          cpos[#cpos+1] = {x,y,c}
        end
      end
    end
    for i = 1, #cpos do
      local x,y = cpos[i][1], cpos[i][2]
      local c = cpos[i][3]
      local sx,sy = ToScreen(x,y)
      if c ~= nil then
        if c.lastvars then
          local cx,cy = ToScreen(c.lastvars[1] or x,c.lastvars[2] or y)
          local crot = c.lastvars[3] or c.rot
          local lval = CurrentTime/TickDelay
          local lerpedr = Lerp(c.lastvars[3],c.lastvars[3]+((c.rot-c.lastvars[3]+2)%4-2),lval)
          DrawCell(Lerp(cx,sx,lval), Lerp(cy,sy,lval), Cam.gzoom, Cam.gzoom, c, lerpedr)
        else
          DrawCell(sx,sy, Cam.gzoom, Cam.gzoom, c)
        end
      end
    end
  end
end

function DrawCell(x,y,w,h,cell,overriderot)
  if cell.id == "empty" then return end
  local usetex = LoveTextures[cell.id] or LoveTextures.nonexistant
  if usetex then
    if overriderot ~= nil then
      love.graphics.draw(usetex, x, y, overriderot*halfpi, w, h, usetex:getWidth()/2, usetex:getHeight()/2)
    else
      love.graphics.draw(usetex, x, y, cell.rot*halfpi, w, h, usetex:getWidth()/2, usetex:getHeight()/2)
    end
  end
end

function DrawBG(x,y,w,h,bg)
  local usetex = LoveBGTextures[bg.id] or LoveBGTextures.empty
  if usetex then
    love.graphics.draw(usetex, x, y, bg.rot*halfpi, w, h, usetex:getWidth()/2, usetex:getHeight()/2)
  end
end
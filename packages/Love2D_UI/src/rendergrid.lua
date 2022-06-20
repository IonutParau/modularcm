local halfpi = math.pi / 2

function RenderGrid()
  if Grid.width ~= nil then
    local stx,sty = ToGrid(0,0)
    local enx,eny = ToGrid(love.graphics.getWidth(),love.graphics.getHeight())
    if stx < 1 then stx = 1 end
    if sty < 1 then sty = 1 end
    if enx > Grid.width then enx = Grid.width end
    if eny > Grid.height then eny = Grid.height end
    for x = stx, enx do
      for y = sty, eny do
        local c = Grid:get(x, y)
        local bg = Grid:getBackground(x,y)
        local sx,sy = ToScreen(x,y)
        if bg ~= nil then
          DrawBG(sx,sy, Cam.gzoom, Cam.gzoom, bg)
        end
        if c ~= nil then
          DrawCell(sx, sy, Cam.gzoom, Cam.gzoom, c)
        end
      end
    end
  else
    local stx,sty = ToGrid(0,0)
    local enx,eny = ToGrid(love.graphics.getWidth(),love.graphics.getHeight())
    for x = stx, enx do
      for y = sty, eny do
        local c = Grid:get(x, y)
        local bg = Grid:getBackground(x,y)
        local sx,sy = ToScreen(x,y)
        if bg == nil then bg = {id = "empty", rot = 0, data = {}} end
        DrawBG(sx,sy, Cam.gzoom, Cam.gzoom, bg)
        if c ~= nil then
          DrawCell(sx, sy, Cam.gzoom, Cam.gzoom, c)
        end
      end
    end
  end
end

function DrawCell(x,y,w,h,cell)
  if cell.id == "empty" then return end
  local usetex = LoveTextures[cell.id] or LoveTextures.nonexistant
  if usetex then
    love.graphics.draw(usetex, x, y, cell.rot*halfpi, w, h, usetex:getWidth()/2, usetex:getHeight()/2)
  end
end

function DrawBG(x,y,w,h,bg)
  local usetex = LoveBGTextures[bg.id] or LoveBGTextures.empty
  if usetex then
    love.graphics.draw(usetex, x, y, bg.rot*halfpi, w, h, usetex:getWidth()/2, usetex:getHeight()/2)
  end
end
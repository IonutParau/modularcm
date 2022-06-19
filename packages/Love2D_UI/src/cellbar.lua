local halfpi = math.pi / 2

function RenderCellBar()
  local winx,winy = love.graphics.getWidth(),love.graphics.getHeight()
  local cellsperpage = math.floor(winx/(70))-2

  love.graphics.draw(BackPage,(20),winy-80,0,3,3)
  love.graphics.draw(NextPage,(winx)-70,winy-80,0,3,3)

  for i = Currentpage*cellsperpage-(cellsperpage-1),Currentpage*cellsperpage do
    local k = i-(Currentpage*cellsperpage-(cellsperpage-1))+1
    local v = Listorder[i]

    if v ~= nil then
      local mx,my = love.mouse.getPosition()
      if v == Selected.id then
        love.graphics.setColor(1,1,1,0.8)
      elseif (mx >= k*70+20 and mx <= k*70+20+(3*16)) and (my >= winy-80 and my <= winy-80+(3*16)) then
        love.graphics.setColor(1,1,1,0.6)
      else
        love.graphics.setColor(1,1,1,0.32)
      end
      local usetex = LoveTextures[v] or LoveTextures.nonexistant
      local offx = (1.5*usetex:getWidth())
      local offy = (1.5*usetex:getHeight())
      love.graphics.draw(usetex,(k*70+20)+offx,(winy-80)+offy,Selected.rot*halfpi,3,3,usetex:getWidth()/2,usetex:getHeight()/2)
      love.graphics.setColor(1,1,1,1)
    end
  end
end

function CellBarClick(x,y)
  local mx,my = x,y
  local winx,winy = love.graphics.getWidth(),love.graphics.getHeight()
  local cellsperpage = math.floor(winx/(70))-2
  for i = Currentpage*cellsperpage-(cellsperpage-1),Currentpage*cellsperpage do
    local k = i-(Currentpage*cellsperpage-(cellsperpage-1))+1
    local v = Listorder[i]

    if v ~= nil then
      if (mx >= k*70+20 and mx <= k*70+20+(3*16)) and (my >= winy-80 and my <= winy-80+(3*16)) then
        Selected.id = v
        Placecells = false
      end
    end
  end

  if (my >= winy-80 and my <= winy-80+(3*16)) then
    if mx >= (winx)-70 and mx <= (winx)-70+(3*16) then
      Currentpage = Currentpage+1
      if Currentpage > math.ceil(#Listorder/cellsperpage) then Currentpage = math.ceil(#Listorder/cellsperpage) end
      Placecells = false
    elseif mx >= 20 and mx <= 20+(3*16) then
      Currentpage = Currentpage-1
      if Currentpage < 1 then Currentpage = 1 end
      Placecells = false
    end
  end
end
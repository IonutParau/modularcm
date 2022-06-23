function ToScreen(x,y)
  local cx = (x * (16*Cam.gzoom))+Cam.gx
  local cy = (y * (16*Cam.gzoom))+Cam.gy
  return cx, cy
end

function ToGrid(x,y)
  local cx = math.floor(((x-Cam.gx)/(16*Cam.gzoom))+0.5)
  local cy = math.floor(((y-Cam.gy)/(16*Cam.gzoom))+0.5)
  return cx,cy
end
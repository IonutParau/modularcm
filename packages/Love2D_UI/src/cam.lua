Cam = {}
Cam.x = 0
Cam.y = 0
Cam.gx = 0
Cam.gy = 0
Cam.zoom = 1
Cam.gzoom = 1
Cam.smoothness = 10

function ResetCam()
  Cam.x = 0
  Cam.y = 0
  Cam.gx = 0
  Cam.gy = 0
  Cam.zoom = 1
  Cam.gzoom = 1
  Cam.smoothness = 10
end

function Cam:interpolate(dt)
  local t = Cam.smoothness * dt
  if t > 1 then t = 1 end
  Cam.gx = Cam.gx + (Cam.x - Cam.gx) * t
  Cam.gy = Cam.gy + (Cam.y - Cam.gy) * t
  Cam.gzoom = Cam.gzoom + (Cam.zoom - Cam.gzoom) * t
end
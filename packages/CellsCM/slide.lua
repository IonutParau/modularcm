Queue("init", function()
  CreateCell("slide", {
    forceProcessor = function(cell, x, y, dir, force, options)
      local s = ToSide(dir, cell.rot)
      if s % 2 ~= 0 then return 0 end
      return force
    end
  })
end)

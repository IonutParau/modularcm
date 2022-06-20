Queue("init", function()
  CreateCell("wall", {
    forceProcessor = function(cell, x, y, dir, force, options)
      return 0
    end,
    canRotate = function() return false end,
  })
end)

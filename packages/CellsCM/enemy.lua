Queue("init", function()
  CreateCell("enemy", {
    shouldDestroyOnMove = function(cell, x, y, dir, force, options)
      Grid:set(x, y, Cell("empty", 0, {}))
      return true
    end,
  })
end)

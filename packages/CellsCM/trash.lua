Queue("init", function()
  CreateCell("trash", {
    shouldDestroyOnMove = function() return true end,
  })
end)

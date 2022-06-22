---@param str string
-- Based on the V2 decoder in https://github.com/TestAccountAaa/Cell-Machine-Mystic-Mod/blob/master/Assets/Assets/Scripts/LoadString.cs
return function(str)
  local segs = SplitStr(str, ';')
  table.remove(segs, 1)

  local length
  local dataIndex = 1
  local gridIndex = 0
  local temp

  local width = VX:decodeNum(segs[1])
  local height = VX:decodeNum(segs[2])

  local grid = FixedGrid(width, height)

  local cells = segs[3]

  local cellData

  while dataIndex <= #cells do
    if cells[dataIndex] == ')' or cells[dataIndex] == '(' then
      cellData = VX.cheatsheet[ cells[dataIndex - 1] ]
      if cells[dataIndex] == ')' then
        dataIndex = dataIndex + 1
        length = VX.cheatsheet[ cells[dataIndex] ]
      else
        dataIndex = dataIndex + 1
        temp = ""
        while cells[dataIndex] ~= ")" do
          temp = temp .. cells[dataIndex]
          dataIndex = dataIndex + 1
        end
        length = VX:decodeNum(temp)
      end

      if cellData ~= 72 then
        for i = 0, length - 1, 1 do
          VX:setCell(grid, cellData, gridIndex + i)
        end
      end
      gridIndex = gridIndex + length
    else
      VX:setCell(grid, VX.cheatsheet[ cells[dataIndex] ], gridIndex)
    end
    dataIndex = dataIndex + 1
  end

  return grid
end

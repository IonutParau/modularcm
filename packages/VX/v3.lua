---@param str string
-- Based on the V3 decoder in https://github.com/TestAccountAaa/Cell-Machine-Mystic-Mod/blob/master/Assets/Assets/Scripts/LoadString.cs
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

  local offset
  local cellDataHistory = {}

  while dataIndex <= #cells do
    if cells:sub(dataIndex, dataIndex) == ")" or cells:sub(dataIndex, dataIndex) == "(" then
      if cells:sub(dataIndex, dataIndex) == ")" then
        dataIndex = dataIndex + 2
        offset = VX.cheatsheet[cells:sub(dataIndex - 1, dataIndex - 1)]
        length = VX.cheatsheet[cells:sub(dataIndex, dataIndex)]
      else
        dataIndex = dataIndex + 1
        temp = ""
        while cells:sub(dataIndex, dataIndex) ~= ")" and cells:sub(dataIndex, dataIndex) ~= "(" do
          if cells:sub(dataIndex, dataIndex) ~= ")" then
            temp = temp .. cells:sub(dataIndex, dataIndex)
            dataIndex = dataIndex + 1
          end
        end
        offset = VX:decodeNum(temp)
        if cells:sub(dataIndex, dataIndex) == ")" then
          dataIndex = dataIndex + 1
          length = VX.cheatsheet[dataIndex]
        else
          dataIndex = dataIndex + 1
          temp = ""
          while cells:sub(dataIndex, dataIndex) ~= ")" do
            if cells:sub(dataIndex, dataIndex) ~= ")" then
              temp = temp .. cells:sub(dataIndex, dataIndex)
              dataIndex = dataIndex + 1
            end
          end
          length = VX:decodeNum(temp)
        end
      end
      for i = 1, length do
        VX:setCell(grid, cellDataHistory[gridIndex - offset - 1], gridIndex)
        cellDataHistory[gridIndex] = cellDataHistory[gridIndex - offset - 1]
        gridIndex = gridIndex + 1
      end
    else
      VX:setCell(grid, VX.cheatsheet[cells:sub(dataIndex, dataIndex)], gridIndex)
      cellDataHistory[gridIndex] = VX.cheatsheet[cells:sub(dataIndex, dataIndex)]
      gridIndex = gridIndex + 1
    end

    dataIndex = dataIndex + 1
  end
end

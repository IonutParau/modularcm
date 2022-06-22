VX = {}
VX.cells = {}
VX.cellKey = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&+-.=?^{}";

local cheatsheet = {}

for i=1,#VX.cellKey do
    cheatsheet[VX.cellKey:sub(i, i)] = (i-1)
end

function VX:decodeNum(n)
    local output = 0

    for i=1,#n do
        output = output * (#VX.cellKey)
        output = output + (cheatsheet[n:sub(i, i)])
    end
    
    return output
end

-- private static void SetCell(int c, int i)
--         {
--             //c is celldata index, i is level position index
--             if (c % 2 == 1)
--                 GridManager.instance.tilemap.SetTile(new Vector3Int(i % CellFunctions.gridWidth, i / CellFunctions.gridWidth, 0), GridManager.instance.placebleTile);
--             if (c >= 72)
--                 return;
--             GridManager.instance.SpawnCell(
--                 (CellType_e)((c / 2) % 9),
--                 new Vector2(i % CellFunctions.gridWidth, i / CellFunctions.gridWidth),
--                 (Direction_e)(c / 18),
--                 false);
--         }

function VX:setCell(c, i)
    local x = i % Grid.width
    local y = Grid.height - math.floor(i / Grid.height) -- We gotta flip it because... Unity
    if c % 2 == 1 then
        Grid:setBackground(x, y, Cell("place", 0, {}))
    end

    if c >= 72 then return end

    Grid:set(x, y, Cell(VX.cells[math.floor(c / 2) % VX.cells], math.floor(c / 18), {}))
end
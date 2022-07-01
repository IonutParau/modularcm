VX = {}
VX.cells = {}
VX.cellKey = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&+-.=?^{}";

VX.cheatsheet = {}

for i = 1, #VX.cellKey do
    VX.cheatsheet[VX.cellKey:sub(i, i)] = (i - 1)
end

function VX:decodeNum(n)
    local output = 0

    for i = 1, #n do
        if VX.cheatsheet[n:sub(i, i)] == nil then return output end
        output = output * (#VX.cellKey)
        output = output + (VX.cheatsheet[n:sub(i, i)])
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

---@param g FixedGrid
---@param c number
---@param i number
function VX:setCell(g, c, i)
    local x = i % g.width + 1
    local y = g.height - math.floor(i / g.height) -- We gotta flip it because... Unity
    if c % 2 == 1 then
        g:setBackground(x, y, Cell("place", 0, {}))
    end

    if c >= 72 then return end

    g:set(x, y, Cell(VX.cells[math.floor(c / 2) % #(VX.cells)], math.floor(c / 18), {}))
end

CreateFormat("V1", "V1;", nil, require("packages.VX.v1"))
CreateFormat("V2", "V2;", nil, require("packages.VX.v2"))
CreateFormat("V3", "V3;", nil, require("packages.VX.v3"))
local format = require("packages.VX.vx")
CreateFormat("VX", "VX:", format.encode, format.decode)

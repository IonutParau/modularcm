local yeses = {
  yes = true,
  y = true
}

local function isYes(value)
  return (yeses[value:lower()] or false)
end

local function BootAsUI()
  print("Launching with Love2D...")
  if not os.execute("love .") and IsWindows then
    os.execute("\"C:\\Program Files\\LOVE\\love.exe\" .")
  end
  os.exit()
end

Queue("init", function()
  if not love then
    print("Would you like to boot with Love2D UI?")
    local answer = io.read()
    if isYes(answer) then
      BootAsUI()
    else
      print("Booting without UI")
    end
  end
end)

BindCommand("love2d-launch", BootAsUI)

BindCommand("love2d-build", function() if IsWindows then os.execute("tar.exe -a -c -f game.zip *") os.execute("mv game.zip game.love") else os.execute("zip -r Game.love .") end end)


if love then
  if CanShell() then ToggleShell() end
  GameScreen = "mainmenu"
  LoveReq = function(file)
    return require("packages.Love2D_UI." .. file)
  end
  LoveTextures = {}
  LoveBGTextures = {}
  function AddTextureToCell(id,texture)
    LoveTextures[id] = texture
  end
  function AddTextureToBackground(id,texture)
    LoveBGTextures[id] = texture
  end
  utf8 = require("utf8")
  love.graphics.setDefaultFilter("nearest", "nearest")
  BackPage = love.graphics.newImage("packages/Love2D_UI/textures/backpage.png")
  NextPage = love.graphics.newImage("packages/Love2D_UI/textures/nextpage.png")
  CellEnv = "default"
  CellEnvs = {}
  function NewCellEnv(name,click,render)
    CellEnvs[name] = {
      click = click,
      render = render
    }
  end
  Currentpage = 1
  Placecells = true
  Placesize = 0
  love.keyboard.setKeyRepeat(true)
  love.window.setMode(800, 600, {
    minwidth = 800,
    minheight = 600,
    resizable = true
  })
  Selected = Cell("mover",0,{})
  Listorder = {}
  AddPostCellCreationListener(function(id,config)
    Listorder[#Listorder+1] = id
  end)
  love.window.setTitle("ModularCM (Love2D UI)")
  LoveReq("src.cam")
  LoveReq("src.UIManager")
  LoveReq("src.createui")
  LoveReq("src.rendergrid")
  LoveReq("src.bindtextures")
  LoveReq("src.handleinput")
  LoveReq("src.grid")
  LoveReq("src.cellbar")
  LoveReq("src.render")
  LoveReq("src.update")
end
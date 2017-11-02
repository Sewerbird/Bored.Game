local LoadAssets = function(Assets)
  --Asset Loading
  Assets.img = {}
  Assets.img.map_tileset = love.graphics.newImage('assets/48HourTileset.png')
  Assets.img.entity_sheet = love.graphics.newImage('assets/48HourEntitySheet.png')
  Assets.img.battlescene = {swamp = { bg = love.graphics.newImage('assets/BattleSceneSwamp.png')}}
  Assets.tileset = {}
  Assets.tileset.ortho_grass = love.graphics.newQuad(0,0,100,100,Assets.img.map_tileset:getDimensions())
  Assets.tileset.wall = love.graphics.newQuad(100,0,100,100,Assets.img.map_tileset:getDimensions())
  Assets.tileset.grass = love.graphics.newQuad(0,100,100,200, Assets.img.map_tileset:getDimensions())
  Assets.sprites = {}
  Assets.sprites.player = {
    front = love.graphics.newQuad(0,0,100,100,Assets.img.entity_sheet:getDimensions()),
    back = love.graphics.newQuad(0,100,100,100,Assets.img.entity_sheet:getDimensions()),
    w = 100,
    h = 100
  }
  Assets.sprites.bear = {
    front = love.graphics.newQuad(200,0,300,200,Assets.img.entity_sheet:getDimensions()),
    w = 300,
    h = 200
  }
  Assets.sprites.berry = {
    fallow = love.graphics.newQuad(500,0,100,100,Assets.img.entity_sheet:getDimensions()),
    ripe = love.graphics.newQuad(500,100,100,100,Assets.img.entity_sheet:getDimensions()),
    w = 100,
    h = 100,
  }
  Assets.sprites.merchant = {
    w = 100,
    h = 100,
    front = love.graphics.newQuad(0,200,100,100,Assets.img.entity_sheet:getDimensions())
  }
  Assets.sprites.sword = {
    w = 100,
    h = 100,
    front = love.graphics.newQuad(600,100,100,100,Assets.img.entity_sheet:getDimensions()) 
  }
  Assets.sprites.potion = {
    w = 100,
    h = 100,
    front = love.graphics.newQuad(600,0,100,100,Assets.img.entity_sheet:getDimensions()) 
  }
  Assets.sprites.torch = {
    w = 100,
    h = 100,
    front = love.graphics.newQuad(700,0,100,100,Assets.img.entity_sheet:getDimensions()) 
  }
  Assets.sprites.reticule = {
    w = 100,
    h = 100,
    front = love.graphics.newQuad(700,100,100,100,Assets.img.entity_sheet:getDimensions()) 
  }
  Assets.ui = {}
  Assets.ui.battlescene_bg = love.graphics.newQuad(0,0,1280,720,Assets.img.battlescene.swamp.bg:getDimensions())
end

return LoadAssets

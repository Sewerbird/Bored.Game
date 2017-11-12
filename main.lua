--Global Utility Libraries
_ = require('lib/moses')
inspect = require('lib/inspect')
uuid = require('lib/uuid')
F = require('lib/F')
require('lib/math_extensions')

--Global Gamestate
Assets = {}
GS = {} --Gamestate

local Gamestate = require('engine/gamestate')

function love.load(args)
  love.math.setRandomSeed(love.math.getRandomSeed())
	print(F"Loading game {args[2]}")
  require(args[2] .. "/assets/import")(F"{args[2]}/assets/",Assets)
  GS = Gamestate.new()
  require(F"{args[2]}/main"):load(GS)
  GAME_RUNNING = true
end

function love.keypressed(key)
  --[[
  GS.inputqueue:add('debugA',{
    begin = function(self)
      print("Beginning debug event A")
    end,
    update = function(self,dt)
    end,
    finish = function(self,dt)
      print(F"Finishing debug event A with {dt} left on the clock")
    end
  },1.1)
  --]]
  if key == 'space' then
    GS.board:endTurn()
  elseif key == 'r' then
    GS = {}
    Assets = {}
    love.load({".","backgammon"})
  end
end

function love.touchpressed(x,y)
  love.mousepressed(x,y)
end

function love.mousepressed(x,y)
  if not GAME_RUNNING then return end
  for i, gid in ipairs(GS.scenegraph:screenPxToGobs(x,y)) do
    local w_x, w_y = GS.scenegraph:screenPxToWorld(x,y)
    if GS[gid].onClick and GS[gid].hitbox:test(GS[gid],w_x,w_y) then
      if GS[gid]:onClick() then break end
    end
  end
  GS.pubsub:publish('mouse','mousepressed',{x = x, y = y})
end

function love.mousemoved(x,y,dx,dy)
  GS.pubsub:publish('mouse','mousemoved',{x = x, y = y, dx = dx, dy = dy})
end

function love.mousereleased(x,y)
  GS.pubsub:publish('mouse','mousereleased',{x = x, y = y})
end

function love.update(dt)
  GS.inputqueue:update(dt)
  GS.scenegraph:traverse(function(gid)
    --Support Anim8 animation
    if GS[gid].animation then
      GS[gid].animation:update(GS[gid],dt)
    end
    --Support Spine animation
    if GS[gid].skeleton then
      GS[gid].skeleton.state:update(dt)
      GS[gid].skeleton.state:apply(GS[gid].skeleton)
      GS[gid].skeleton:updateWorldTransform()
    end
  end)
end

function love.draw()
  local dy = 0
  GS.scenegraph:traverse(
  function(gid) 
    love.graphics.push()
    love.graphics.translate(GS[gid].world_x,GS[gid].world_y) 
  end, 
  function(gid) 
    --Respect draw function, but default to animating
    if GS[gid].draw then
      GS[gid]:draw()
    else
      --Support Anim8 animation
      if GS[gid].animation then
        GS[gid].animation:draw(GS[gid])
      end
      --Support Spine animation
      if GS[gid].skeleton then
        GS[gid].skeleton:draw(GS[gid])
      end
    end
    love.graphics.pop() 
  end)
end


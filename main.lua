--Global Utility Libraries
_ = require('lib/moses')
inspect = require('lib/inspect')
uuid = require('lib/uuid')
F = require('lib/F')
require('lib/math_extensions')

--Global Gamestate
--TODO: Remove
Assets = {}
GS = {} --Gamestate

local Gamestate = require('engine/gamestate')

function love.load(args)
	print(F"Loading game {args[2]}")
  GS = require(F"{args[2]}/main"):load(Gamestate.new())
end

function love.keypressed(key)
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
end

function love.mousepressed(x,y)
  for i, gid in ipairs(GS.scenegraph:screenPxToGobs(x,y)) do
    if GS[gid].animation then
      GS[gid].animation.red = math.floor(math.random() * 255) 
      GS[gid].animation.blue = math.floor(math.random() * 255) 
      GS[gid].animation.green = math.floor(math.random() * 255) 
      print(F"Clicked on {gid}")
    end
  end
end

function love.update(dt)
  GS.inputqueue:update(dt)
  GS.scenegraph:traverse(function(gid)
    --Support Anim8 animation
    if GS[gid].animation then
      GS[gid].animation:update(dt)
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
    --Draw debug information
    if GS[gid].clickbox then
      GS[gid].clickbox:draw(GS[gid])
    end
    --Support Anim8 animation
    if GS[gid].animation then
      GS[gid].animation:draw(GS[gid])
    end
    --Support Spine animation
    if GS[gid].skeleton then
      GS[gid].skeleton:draw(GS[gid])
    end
    love.graphics.pop() 
  end)
end


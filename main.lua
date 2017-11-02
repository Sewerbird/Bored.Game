--Global Utility Libraries
_ = require('lib/moses')
class = require('lib/class')
inspect = require('lib/inspect')
uuid = require('lib/uuid')

--Global Gamestate
--TODO: Remove
Assets = {}
GS = {} --Gamestate

local Gob = require('engine/Gob')
local SceneGraphRelation = require('engine/render_graph')

local scenegraph = nil

function love.load()
  require('src/Assets')(Assets)

  local gobset = _.times(10, function(i)
    local g = Gob(GS,{
      world_x = 100,
      world_y = 100 * i,
      clickbox = {
        world_w = 100,
        world_h = 100,
        origin_x = -50,
        origin_y = -50,
        draw = function(self,gob)
          love.graphics.push()
          love.graphics.translate(self.origin_x,self.origin_y)
          love.graphics.rectangle('line',0,0,gob.clickbox.world_w,gob.clickbox.world_h)
          love.graphics.pop()
        end
      },
      animation = {
        frames = {"A","B","C","D","E"},
        curr_frame = 1,
        timer = 0,
        red = 255,
        green = 255,
        blue = 255,
        origin_x = -5,
        origin_y = -5,
        frame_duration = 1/1,
        update = function(self, dt)
          self.timer = self.timer + dt
          if self.timer > self.frame_duration then
            self.timer = self.timer - self.frame_duration
            self.curr_frame = math.mod(self.curr_frame,#self.frames)+1
          end
        end,
        draw = function(self,gob)
          love.graphics.push()
          love.graphics.translate(self.origin_x,self.origin_y)
          love.graphics.setColor(self.red,self.green,self.blue)
          love.graphics.print(self.frames[self.curr_frame])
          love.graphics.setColor(255,255,255)
          love.graphics.pop()
        end
      }
    })
    return g.gid
  end)

  scenegraph = SceneGraphRelation.over(gobset)
	
end

function love.keypressed(key)
end

function love.mousepressed(x,y)
  gids = scenegraph:screenPxToGobs(x,y)
  for i, gid in ipairs(scenegraph:screenPxToGobs(x,y)) do
    if GS[gid].animation then
      GS[gid].animation.red = math.floor(math.random() * 255) 
      GS[gid].animation.blue = math.floor(math.random() * 255) 
      GS[gid].animation.green = math.floor(math.random() * 255) 
      print("Clicked on " .. gid)
    end
  end
end

function love.update(dt)
  scenegraph:traverse(function(gid)
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
  scenegraph:traverse(
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


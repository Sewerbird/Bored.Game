local EventQueue = require('core/EventQueue')
local MessageBus = require('core/MessageBus')
local CoordinateSystem = require('core/CoordinateSystem')
local SceneGraph = require('core/SceneGraph')

local Scene = {}

Scene.__index = Scene

Scene.new = function (init)
  local self = setmetatable({},Scene)
  self.gid = uuid()
  self.input_queue = EventQueue.new() --For when the players want a say
  self.event_queue = EventQueue.new() --For when the gamerules happen
  self.message_bus = MessageBus.new() --For notifying the game objects
  self.worldspace = GS:add(CoordinateSystem.new('worldspace'))
  self.scenegraph = GS:add(SceneGraph.new('scenespace',self.worldspace))

  --Locate the root element at the origin of worldspace and the base of the hierarchy
  self.root = GS:addBlank()
  GS[self.scenegraph]:place(self.root,nil,0,0,0)
  
  --Subscribe to standard events
  self.message_bus:subscribe(self.gid,"mouse", function() print "Mouse event" end)
  self.message_bus:subscribe(self.gid,"keyboard", function() print "Key event" end)

  return self
end

function Scene:draw()
  local to_draw = {}
  GS[self.scenegraph]:traverse(self.root, function(self, tgt_gid)
    if GS[tgt_gid].worldspace then
      love.graphics.push()
      screencoord = GS[GS.screenspace]:convertFromSystem('worldspace', GS[tgt_gid].worldspace)
      love.graphics.translate(screencoord.x, screencoord.y)
    end
    if GS[tgt_gid].draw then
      GS[tgt_gid]:draw()
    end
  end, nil, function(self, tgt_gid)
    if GS[tgt_gid].worldspace then
      love.graphics.pop()
    end
  end)
end

function Scene:update(dt)
  self.input_queue:update(dt)
  self.event_queue:update(dt)
end

function Scene:input(channel, event)
  --This lets us reify mouse/keyboard/etc events
  self.input_queue:add(channel, event)
end

function Scene:addToScene(gids, parent, x, y, z)
  x = x or 0
  y = y or 0
  z = z or 0
  if type(gids) ~= "table" then
    gids = { gids }
  end
  for i, gid in ipairs(gids) do
    print(F"Scene adding {gid} {inspect({x,y,z})}")
    GS[self.scenegraph]:place(gid, parent, x, y, z)
  end
end

return Scene

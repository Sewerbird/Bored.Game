local EventQueue = require('core/EventQueue')
local MessageBus = require('core/MessageBus')
local SceneGraph = require('core/SceneGraph')

local OrthographicCamera = {}
OrthographicCamera.__index = OrthographicCamera
OrthographicCamera.new = function(graph, target)
  local self = setmetatable({},OrthographicCamera)
  self.gid = uuid()
  self.graph = graph
  self.target = target
  return self
end
function OrthographicCamera:draw()
  --Sort scenegraph by Z
  local scene_ids = {}
  GS[self.graph]:traverse(self.target,function(self, gid)
    table.insert(scene_ids, gid)
  end)
  --Draw all
  print(F"Scene_ids has size {#scene_ids}")
  for i, gid in ipairs(scene_ids) do
    if GS[gid].splat then
      print("Drawing a splat")
      GS[gid].splat:draw()
    end
  end
end

local Scene = {}

Scene.__index = Scene

Scene.new = function (init)
  local self = setmetatable({},Scene)
  self.gid = uuid()
  self.input_queue = EventQueue.new() --For when the players want a say
  self.message_bus = MessageBus.new() --For notifying the game objects
  self.scenegraph = GS:add(SceneGraph.new()) --Define a scenegraph with a default origin root
  self.camera = GS:add(OrthographicCamera.new(self.scenegraph, GS[self.scenegraph].root)) --Specify a camera for the scene
  
  --Subscribe to standard events
  self.message_bus:subscribe(self.gid, "mouse", function() print "Mouse event" end)
  self.message_bus:subscribe(self.gid, "keyboard", function() print "Key event" end)
  self.message_bus:subscribe(self.gid, "time", function() print "Time passed" end)
  self.message_bus:subscribe(self.gid, self.gid, function() print "Got direct event" end)

  return self
end

function Scene:draw()
  GS[self.camera]:draw()
end

function Scene:update(dt)
  self.input_queue:update(dt)
end

function Scene:input(channel, event)
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
    print(F"Scene adding {gid} @ {inspect({x,y,z})}")
    GS[self.scenegraph]:place(gid, parent, x, y, z)
  end
end

return Scene

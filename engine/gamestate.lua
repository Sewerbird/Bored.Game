local Gamestate = {}

Gamestate.__index = Gamestate 

Gamestate.new = function (init)
  local self = setmetatable({}, Gamestate)

  return self
end

function Gamestate:add(gob)
  assert(gob.gid, 'Game object must have a `gid` field with a uuid, but received ' .. inspect(gob))
  self[gob.gid] = gob
  return gob.gid
end

function Gamestate:addAll(gobset)
  local gids= {}
  for i, gob in ipairs(gobset) do
    self:add(gob)
    table.insert(gids, gob.gid)
  end
  return gids
end

function Gamestate:remove(gid)
  self[gob.gid] = nil
end

return Gamestate

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

return Gamestate

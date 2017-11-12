local Player = {}

Player.__index = Player

Player.new = function()
  local self = setmetatable({},Player)
  return self
end

return Player

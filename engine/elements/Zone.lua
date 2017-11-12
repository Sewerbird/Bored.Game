local HitBox = require("engine/components/HitBox")
local Animation = require("engine/components/Animation")

local Zone = {}

Zone.__index = Zone

Zone.new = function(world_x, world_y, width, height,label,shape,appearance)
  local self = setmetatable({},Zone)
  self.gid = uuid()
  self.is_tile = true
  self.world_x = world_x
  self.world_y = world_y
  self.width = width
  self.height = height
  self.hitbox = HitBox.new(width,height,0,0,shape or 'iso')
  self.appearance = appearance
  if self.appearance then
    self.animation = Animation.new(
      Assets.img[self.appearance],
      {
        Assets.quad[self.appearance]
      },
      1/30,
      -width/2,-height/2,
      width, height
    )
  end
  return self
end

function Zone:draw()
  if self.animation then
    self.animation:draw(self)
  end
end

return Zone

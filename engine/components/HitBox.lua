local HitBox = {}

HitBox.__index = HitBox

HitBox.new = function(world_w, world_h, origin_x, origin_y, shape)
  local self = setmetatable({},HitBox)
  self.world_w = world_w
  self.world_h = world_h
  self.origin_x = origin_x
  self.origin_y = origin_y
  self.shape = shape or "rect"
  return self
end

function HitBox:test(gob, test_x, test_y)
  if self.shape == 'rect' then
    return math.contains(test_x, gob.world_x + self.origin_x - self.world_w/2, gob.world_x + self.world_w/2 + self.origin_x)
       and math.contains(test_y, gob.world_y + self.origin_y - self.world_w/2, gob.world_y + self.world_h/2 + self.origin_y)
  elseif self.shape == 'circle' then
    return math.dist({test_x,test_y}, {gob.world_x + self.origin_x, gob.world_y + self.origin_y}) < self.world_w/2
  elseif self.shape == 'iso' then
    test_x = test_x - gob.world_x
    test_y = test_y - gob.world_y
    local lines = { {-self.world_w/2,0, 0,self.world_h/2},{0,self.world_h/2 , self.world_w/2,0},{-self.world_w/2,0, 0,-self.world_h/2},{0,-self.world_h/2 , self.world_w/2,0} }
    local a = test_y <= ( (lines[1][4] - lines[1][2])/(lines[1][3] - lines[1][1])) * (test_x - lines[1][1])
    local b = test_y <= ( (lines[2][2] - lines[2][4])/(lines[2][1] - lines[2][3])) * (test_x - lines[2][3])
    local c = test_y  > ( (lines[3][4] - lines[3][2])/(lines[3][3] - lines[3][1])) * (test_x - lines[3][1])
    local d = test_y  > ( (lines[4][2] - lines[4][4])/(lines[4][1] - lines[4][3])) * (test_x - lines[4][3]) 

    return a and b and c and d
  end
end

function HitBox:draw(gob)
  love.graphics.push()
  love.graphics.translate(self.origin_x,self.origin_y)
  if self.dragable and self.dragable.active then
    love.graphics.setColor(255,0,0)
  end
  if self.shape == 'rect' then
    love.graphics.rectangle('line',-self.world_w/2,-self.world_h/2,gob.hitbox.world_w,gob.hitbox.world_h)
  elseif self.shape == 'circle' then
    local r = self.world_w / 2
    love.graphics.circle('line',0,0,r)
  elseif self.shape == 'iso' then
    love.graphics.polygon('line',-self.world_w/2,0 , 0,self.world_h/2 , self.world_w/2,0 , 0,-self.world_h/2)
  end
  if self.dragable and self.dragable.active then
    love.graphics.setColor(255,255,255)
  end
  love.graphics.pop()
end

return HitBox

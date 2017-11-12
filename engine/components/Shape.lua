local Shape = {}

Shape.__index = Shape

Shape.circle = function(radius,rotation,o_x, o_y)
  local self = setmetatable({}, Shape)
  self.shape = 'circle'
  self.radius = radius
  self.rotation = rotation
  self.origin_x = o_x
  self.origin_y = o_y
  return self
end

Shape.rect = function(width,height,rotation,o_x,o_y)
  local self = setmetatable({}, Shape)
  self.shape = 'rect'
  self.width = width
  self.height = height
  self.rotation = rotation
  self.origin_x = o_x
  self.origin_y = o_y
  return self
end

Shape.iso = function(width,height,rotation,o_x,o_y)
  local self = setmetatable({}, Shape)
  self.shape = 'iso'
  self.width = width
  self.height = height
  self.rotation = rotation
  self.origin_x = o_x
  self.origin_y = o_y
  return self
end

Shape.ellipse = function(width,height,rotation, o_x, o_y)
  local self = setmetatable({}, Shape)
  self.shape = 'ellipse'
  self.width = width
  self.height = height
  self.rotation = rotation
  self.origin_x = o_x
  self.origin_y = o_y
end

Shape.polygon = function(points, rotation, o_x, o_y)
  local self = setmetatable({}, Shape)
  self.shape = 'polygon'
  self.rotation = rotation
  self.origin_x = o_x
  self.origin_y = o_y
end

function Shape:contains(test_x, test_y)
  if self.shape == 'rect' then
    return math.contains(test_x, gob.world_x + self.origin_x - self.world_w/2, gob.world_x + self.world_w/2 + self.origin_x)
       and math.contains(test_y, gob.world_y + self.origin_y - self.world_w/2, gob.world_y + self.world_h/2 + self.origin_y)
  elseif self.shape == 'circle' then
    return math.dist({test_x,test_y}, {gob.world_x + self.origin_x, gob.world_y + self.origin_y}) < self.world_w/2
  elseif self.shape == 'ellipse' then
    assert(false, "Ellipse containment is not implemented yet, sorry!")
  elseif self.shape == 'polygon' then
    assert(false, "Polygon containment is not implemented yet, sorry!")
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

return Shape

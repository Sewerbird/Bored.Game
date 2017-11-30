local Rectangle = {}
local Circle = {}
local Ellipse = {}
local Polygon = {}
local Iso = {}

local Shape = {}

Shape.__index = Shape

Shape.circle = function(radius,rotation,o_x, o_y)
  local self = setmetatable({}, Circle)
  self.shape = 'circle'
  self.radius = radius
  self.rotation = rotation or 0
  self.origin_x = o_x or 0
  self.origin_y = o_y or 0
  return self
end

Shape.rect = function(width,height,rotation,o_x,o_y)
  local self = setmetatable({}, Rectangle)
  self.shape = 'rect'
  self.width = width
  self.height = height
  self.rotation = rotation or 0
  self.origin_x = o_x or 0
  self.origin_y = o_y or 0
  return self
end

Shape.iso = function(width,height,rotation,o_x,o_y)
  local self = setmetatable({}, Iso)
  self.shape = 'iso'
  self.width = width
  self.height = height
  self.rotation = rotation or 0
  self.origin_x = o_x or 0
  self.origin_y = o_y or 0
  return self
end

Shape.ellipse = function(width,height,rotation, o_x, o_y)
  local self = setmetatable({}, Ellipse)
  self.shape = 'ellipse'
  self.width = width
  self.height = height
  self.rotation = rotation or 0
  self.origin_x = o_x or 0
  self.origin_y = o_y or 0
end

Shape.polygon = function(points, rotation, o_x, o_y)
  local self = setmetatable({}, Polygon)
  self.shape = 'polygon'
  self.points = points
  self.rotation = rotation or 0
  self.origin_x = o_x or 0
  self.origin_y = o_y or 0
end

--Rectangle
function Rectangle:contains(test_x, test_y)
  return math.contains(test_x, self.origin_x - self.width/2, self.width/2 + self.origin_x)
     and math.contains(test_y, self.origin_y - self.height/2, self.height/2 + self.origin_y)
end

function Rectangle:draw()
  love.graphics.push()
  love.graphics.translate(self.origin_x, self.origin_y)
  love.graphics.rectangle('line', self.width, self.height)
  love.graphics.pop()
end

--Circle
function Circle:contains(test_x, test_y)
  return math.dist({test_x,test_y}, {self.origin_x, self.origin_y}) < self.radius
end

function Circle:draw()
  love.graphics.push()
  love.graphics.translate(self.origin_x, self.origin_y)
  love.graphics.circle('line', self.radius)
  love.graphics.pop()
end

--Iso
function Iso:contains(test_x, test_y)
  return math.abs(test_y-self.origin_y) < (self.height/2)-(self.height/self.width * math.abs(test_x-self.origin_x))
end

function Iso:draw()
  love.graphics.push()
  love.graphics.translate(self.origin_x, self.origin_y)
  love.graphics.polygon('line',-self.width/2,0 , 0,self.width/2 , self.width/2,0 , 0,-self.weight/2)
  love.graphics.pop()
end

--Ellipse
function Ellipse:contains(test_x, test_y)
  assert(false, "Sorry, ellipse isn't completely implemented yet")
end

function Ellipse:draw()
  love.graphics.push()
  love.graphics.translate(self.origin_x, self.origin_y)
  love.graphics.ellipse('line', 0,0, self.width, self.height)
  love.graphics.pop()
end

--Polygon
function Ellipse:contains(test_x, test_y)
  assert(false, "Sorry, polygon isn't completely implemented yet")
end

function Polygon:draw()
  love.graphics.push()
  love.graphics.translate(self.origin_x, self.origin_y)
  love.graphics.polygon('line',self.points)
  love.graphics.pop()
end

return Shape

local SceneGraph = {}

SceneGraph.__index = SceneGraph

SceneGraph.new = function(name, coordinate_system)
  local self = setmetatable({},SceneGraph)
  self.coordinate_space = coordinate_system --Used later for defining transformation
  self.gid = uuid()
  self.type = 'SceneGraph'
  self.name = name
  self.definesTo = {}
  self.definesFrom = {}
  return self
end

function SceneGraph:place(gid, parent, x, y, z)
  x = x or 0
  y = y or 0
  z = z or 0
  GS[gid][self.name] = { 
    parent = parent,
    system = self.gid, 
    children = {}
  }
  GS[self.coordinate_space]:place(gid, x, y, z)
  if GS[parent] and GS[parent][self.name] then table.insert(GS[parent][self.name].children, gid) end
  return gid
end

function SceneGraph:reparent(gid, new_parent)
  GS[GS[gid][self.name].parent][self.name].children[gid] = false
  GS[gid][self.name].parent = new_parent
  if GS[parent] and GS[parent][self.name] then table.insert(GS[parent][self.name].children, gid) end
  return gid
end

function SceneGraph:traverse(root_gid, pre_fn, in_fn, post_fn)
  local pre, post

  if pre_fn then
    pre = pre_fn(self, root_gid)
  end

  if GS[root_gid][self.name].children then
    for i, key in ipairs(GS[root_gid][self.name].children) do
      local in_pre, in_post = self:traverse(key, pre_fn, in_fn, post_fn)
      if in_fn then in_fn(self, root_gid, in_pre, in_post) end
    end
  end

  if post_fn then post = post_fn(self, root_gid) end

  return pre, post
end

function SceneGraph:ascend(tgt_gid, fn)
  local val = fn(tgt_gid)
  if GS[tgt_gid][self.name].parent then
    self:ascend(GS[tgt_gid][self.name].parent)
  end
  return val
end

function SceneGraph:convertToSystem(them_system, me_coord)
  assert(self.definesTo[them_system], F"No conversion from me to {them_system} defined yet")
  return self.definesTo[them_system](me_coord)
end

function SceneGraph:convertFromSystem(them_system, them_coord)
  assert(self.definesFrom[them_system], F"No conversion from {them_system} to me defined yet")
  return self.definesFrom[them_system](them_coord)
end

function SceneGraph:defineTo(tgt_system_name, fn)
  self.definesTo[tgt_system_name] = fn
end

function SceneGraph:defineFrom(tgt_system_name, fn)
  self.definesFrom[tgt_system_name] = fn
end

return SceneGraph

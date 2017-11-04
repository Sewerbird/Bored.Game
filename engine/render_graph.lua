local RenderGraph = {}

RenderGraph.__index = RenderGraph

RenderGraph.new = function()
  local self = setmetatable({}, RenderGraph)
  self.root = {
    gid = uuid(),
    world_x = 0,
    world_y = 0
  }
  self.set = {}
  self.set[self.root.gid] = { nid = gid, up = {}, down = {} }
	return self
end

function RenderGraph.over(set)
  local result = RenderGraph.new()
  for i, gid in ipairs(set) do
    result:add(gid, nil)
  end
  return result
end

function RenderGraph:add(gid, parent_gid)
	self.set[gid] = { nid = gid, up = {}, down = {} }
  if not parent_gid then parent_gid = self.root.gid end
  self:link(parent_gid, gid)
  return self
end

function RenderGraph:link(parent_gid, child_gid)
  --TODO: Check that no cycle is introduced
  table.insert(self.set[parent_gid].down, child_gid)
  table.insert(self.set[child_gid].up, parent_gid)
end

function RenderGraph:remove(gid)
  self.set[gid] = nil
  return self
end

function RenderGraph:traverse(tgt_gid, pre_fn, post_fn)
 if type(tgt_gid) == 'function' then 
   post_fn = pre_fn
   pre_fn = tgt_gid
   tgt_gid = self.root.gid .. ""
 end

 local a = pre_fn and pre_fn(tgt_gid) or nil
 for k, v in ipairs(self.set[tgt_gid].down) do
   self:traverse(v, pre_fn, post_fn)
 end
 local b = post_fn and post_fn(tgt_gid) or nil

 return a, b
end

function RenderGraph:screenPxToGobs(s_x,s_y)
  local w_x = self.root.world_x + s_x
  local w_y = self.root.world_y + s_y

  local result = {}
  local gob, a, b

  --TODO: this checks everything. Might be fun to do a more refined datastructure
  for gid, _ in pairs(self.set) do
    gob = GS[gid]
    if gob.clickbox ~= nil then
      a = math.contains(w_x,gob.world_x + gob.clickbox.origin_x, gob.world_x + gob.clickbox.world_w + gob.clickbox.origin_x)
      b = math.contains(w_y,gob.world_y + gob.clickbox.origin_y, gob.world_y + gob.clickbox.world_h + gob.clickbox.origin_y)
      if a and b then table.insert(result,gid) end
    end
  end

  return result
end

return RenderGraph


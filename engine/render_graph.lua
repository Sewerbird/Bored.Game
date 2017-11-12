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

function RenderGraph:addAll(arr_gid, parent_gid)
  for i, gid in ipairs(arr_gid) do
    self:add(gid,parent_gid)
  end
  return self
end

function RenderGraph:relink(child_gid, new_parent_gid)
  local parent_gid = self.set[child_gid].up[1]
  table.insert(self.set[child_gid].up, new_parent_gid)
  table.insert(self.set[new_parent_gid].down, child_gid)
  local idx
  for i, child in ipairs(self.set[parent_gid].down) do
    if child == child_gid then
      idx = i
    end
  end
  table.remove(self.set[parent_gid],idx)
  self:sortByY(new_parent_gid)
end

function RenderGraph:link(parent_gid, child_gid)
  --TODO: Check that no cycle is introduced
  table.insert(self.set[parent_gid].down, child_gid)
  table.insert(self.set[child_gid].up, parent_gid)
  self:sortByY(parent_gid)
end

function RenderGraph:remove(gid)
  self.set[gid] = nil
  return self
end

function RenderGraph:sortByY(root)
  if root == nil then root = self.root.gid end
  table.sort(self.set[root].down, function(a,b)
    if a and b then
      assert(GS[a] and GS[b], F"Error y-sorting. a({inspect(a)}): {inspect(GS[a])}, b({inspect(b)}): {inspect(GS[b])}")
      return GS[a].world_y < GS[b].world_y
    elseif a == nil then
      return false
    elseif b == nil then
      return true
    end
  end)
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

function RenderGraph:screenPxToWorld(s_x,s_y)
  local w_x = self.root.world_x + s_x
  local w_y = self.root.world_y + s_y
  return w_x, w_y
end

function RenderGraph:worldPxToGobs(w_x,w_y)
  local result = {}
  local gob, a, b

  --TODO: this checks everything. Might be fun to do a more refined datastructure
  for gid, _ in pairs(self.set) do
    gob = GS[gid]
    if gob and gob.hitbox ~= nil and gob.hitbox:test(gob, w_x,w_y) then 
      table.insert(result,gid) 
    end
  end

  return result
end

function RenderGraph:screenPxToGobs(s_x,s_y)
  local w_x, w_y = self:screenPxToWorld(s_x,s_y)

  return self:worldPxToGobs(w_x,w_y)
end

return RenderGraph


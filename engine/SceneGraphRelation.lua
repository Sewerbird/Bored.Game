local Relation = require('engine/relation')
local Gob = require('engine/gob')

local SceneGraphRelation = Class(Relation, function(self)
  Relation.init(self)
  self.root = Gob(GS)
  self.root.world_x = 300
  self.root.world_y = 300
  self.set[self.root.gid] = { nid = gid, up = {}, down = {} }
end)

function SceneGraphRelation.over(set)
  return _.reduce(set, function(relation, gid) return relation:add(gid, nil) end, SceneGraphRelation())
end

function SceneGraphRelation:add(gid, parent_gid)
	self.set[gid] = { nid = gid, up = {}, down = {} }
  if not parent_gid then parent_gid = self.root.gid end
  self:link(parent_gid, gid)
  return self
end

function SceneGraphRelation:link(parent_gid, child_gid)
  --TODO: Check that no cycle is introduced
  table.insert(self.set[parent_gid].down, child_gid)
  table.insert(self.set[child_gid].up, parent_gid)
end

function SceneGraphRelation:remove(gid_gob)
  if type(gob) == 'string' then self.set[gid] = nil
  elseif type(gob) == 'table' then self.set[gid_gob.gid] = nil end
  return self
end

function SceneGraphRelation:traverse(tgt_gid, pre_fn, post_fn)
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

return SceneGraphRelation


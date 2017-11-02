local Relation = class(function (self)
	self.set = {}
end)

function Relation.over(set, f)
  if not f then f = Relation.add end
  return _.reduce(set, function(relation, gob) return f(relation, gob) end, Relation())
end

function Relation:add(gid)
	self.set[gid] = gid
  return self
end

function Relation:remove(gid)
  self.set[gid] = nil
  return self
end

return Relation

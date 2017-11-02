local Gob = class(function (self, gamestate, payload)
	self.gid = uuid()
  if payload then
    for k, v in pairs(payload) do
      self[k] = v
    end
  end
  gamestate[self.gid] = self
  return self
end)

return Gob

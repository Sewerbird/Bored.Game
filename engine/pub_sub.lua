local PubSub = {}

PubSub.__index = PubSub

PubSub.new = function(self)
	local self = setmetatable({},PubSub)
  self.topics = {}
  self.queue = {}
	return self
end

function PubSub:publish(topic, event, data)
  if not self.topics[topic] then return end
  for subscriber, callback in pairs(self.topics[topic]) do
    callback(event, data)
  end
end

function PubSub:subscribe(subscriber, topic, callback)
  assert(topic, F"You must subscribe to a specific topic, but you subscribed to {topic}")
  assert(callback, F"You must provide a callback for the topic, but you provided none")
  if not self.topics[topic] then self.topics[topic] = {} end
  self.topics[topic][subscriber] = callback
end

function PubSub:unsubscribe(subscriber, topic)
  if not topic then
    for topic, v in pairs(self.topics) do
      self.topics[topic][subscriber] = nil
    end
  else
    self.topics[topic][subscriber] = nil
  end
end

return PubSub

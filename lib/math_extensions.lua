math.contains = function(val,low,high)
  if low > high then c = low; low = high; high = c end
  return low < val and val < high
end

math.clamp = function(val,low,high)
  if low > high then c = low; low = high; high = c end
  return math.floor(math.max(math.min(val,high),low))
end

math.clampf = function(val, low, high)
  if low > high then c = low; low = high; high = c end
  return math.max(math.min(val,high),low)
end

math.lerp = function(a, b, dt)
  assert(#a == #b, F"you must lerp tuples with the same dimension, but you have {inspect(a)} with {inspect(b)}")

  local result = {}
  for i = 1, #a do
    local w = b[i] - a[i]
    table.insert(result, (w * dt) / w + a[i] )
  end
  return result
end

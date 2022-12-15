function dist(x1, y1, x2, y2)
   return math.abs(x1 - x2) + math.abs(y1 - y2)
end

function read()
   local t = {}
   for s in io.lines() do
      local m = string.gmatch(s, "x=([%d-]+), y=([%d-]+)")
      local x1, y1 = m()
      local x2, y2 = m()
      x1, y1, x2, y2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)
      table.insert(t, {x1 = x1, y1 = y1, x2 = x2, y2 = y2})
   end
   return t
end

function update(r, y, x1, y1, d)
   local i = 0
   while dist(x1, y1, x1 + i, y) <= d do
      if not r[x1 + i] then r[x1 + i] = '#' end
      if not r[x1 - i] then r[x1 - i] = '#' end
      i = i + 1
   end
end

function count(r)
   local i = 0
   for _, v in pairs(r) do
      if v ~= 'B' then i = i + 1 end
   end
   return i
end

function main()
   local t = read()
   local r = {}
   local y = 2000000
   for _, v in pairs(t) do
      if v.y1 == y then r[v.x1] = 'S' end
      if v.y2 == y then r[v.x2] = 'B' end
   end
   for _, v in pairs(t) do
      update(r, y, v.x1, v.y1, dist(v.x1, v.y1, v.x2, v.y2))
   end
   return count(r)
end

print(main())

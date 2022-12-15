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
      table.insert(t, {x1 = x1, y1 = y1, d = dist(x1, y1, x2, y2)})
   end
   return t
end

function proj(a, y)
   local z = a.d - math.abs(a.y1 - y)
   if z >= 0 then
      return a.x1 - z, a.x1 + z
   end
end

function search(t, y, m)
   local s = {}
   for _, a in pairs(t) do
      if proj(a, y) then -- the ball around a intersects row y
         table.insert(s, a)
      end
   end
   local function cmp(a, b)
      local l1, _ = proj(a, y)
      local l2, _ = proj(b, y)
      return l1 < l2
   end
   table.sort(s, cmp)
   local last = -1
   for i, a in ipairs(s) do
      local l, r = proj(a, y)
      if last + 1 < l then return m * (l - 1) + y end
      if r > last then last = r end
   end
   if last < m then
      return m * m + y
   end
end

function main()
   local t = read()
   local m = 4000000
   for y = 0, m do
      local f = search(t, y, m)
      if f then return f end
   end
   assert(nil)
end

print(main())

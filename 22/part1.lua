function nextdir(s)
   local pos = 0
   return function ()
      if pos > string.len(s) then return end
      local c = string.sub(s, pos, pos)
      if c == 'R' or c == 'L' then
         pos = pos + 1
         return c
      end
      local n, p = string.match(s, "^(%d+)()", pos)
      pos = p
      return tonumber(n)
   end
end

function tableofstring(s)
   local t = {}
   for i = 1, string.len(s) do
      table.insert(t, string.sub(s, i, i))
   end
   return t
end

-- read grid in t[y][x] format
function read()
   local lines = io.lines()
   local t = {}
   for s in lines do
      if s == "" then break end
      table.insert(t, tableofstring(s))
   end
   return t, nextdir(lines())
end

function domove(t, x, y, x1, y1)
   if t[y1][x1] == '#' then
      return x, y
   elseif t[y1][x1] == '.' then
      return x1, y1
   else
      print(x, y, x1, y1, t[y1][x1])
      assert(nil)
   end
end

function dostep(t, x, y, o)
   if o == 0 then -- right
      local x1 = x + 1
      if x1 > #t[y] then -- wrap around
         local j = 1
         while t[y][j] == ' ' do
            j = j + 1
         end
         -- print(x1, y, j, y)
         x1 = j
      end
      return domove(t, x, y, x1, y)
   end
   if o == 1 then -- down
      local y1 = y + 1
      if not t[y1] or not t[y1][x] then -- wrap around
         local j = 1
         while t[j][x] == ' ' do
            j = j + 1
         end
         -- print(x, y1, x, j)
         y1 = j
      end
      return domove(t, x, y, x, y1)
   end
   if o == 2 then -- left
      local x1 = x - 1
      if x1 == 0 or t[y][x1] == ' ' then -- wrap around
         -- print(x1, y, #t[y], y)
         x1 = #t[y]
      end
      return domove(t, x, y, x1, y)
   end
   if o == 3 then -- up
      local y1 = y - 1
      if y1 == 0 or t[y1][x] == ' ' then -- wrap around
         local j = #t
         while not t[j][x] or t[j][x] == ' ' do
            j = j - 1
         end
         -- print(x, y1, x, j)
         y1 = j
      end
      return domove(t, x, y, x, y1)
   end
end

-- orientation o
-- 0 = right
-- 1 = down
-- 2 = left
-- 3 = up

function eval(t, d, x, y, o)
   if d == 'L' then
      o = (o - 1) % 4
   elseif d == 'R' then
      o = (o + 1) % 4
   else -- type(d) == "number"
      for _ = 1, d do
         x, y = dostep(t, x, y, o)
      end
   end
   return x, y, o
end

function find(t, x)
   for i = 1, #t do
      if t[i] == x then
         return i
      end
   end
end

function main()
   local t, nextdir = read()
   local x = find(t[1], '.')
   local y, o = 1, 0 -- facing right
   for d in nextdir do
      x, y, o = eval(t, d, x, y, o)
   end
   return 1000 * y + 4 * x + o
end

print(main())

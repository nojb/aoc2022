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

function tableofstring(s, startpos, endpos)
   local t = {}
   for i = startpos, endpos do
      table.insert(t, string.sub(s, i, i))
   end
   return t
end

-- read grid cube:
--     1 2
--     3
--   4 5
--   6

-- orientation o
-- 0 = right
-- 1 = down
-- 2 = left
-- 3 = up

-- face side length
N = 50

function read()
   local t = { {}, {}, {}, {}, {}, {} }
   for _ = 1, N do
      local s = io.read()
      table.insert(t[1], tableofstring(s, N + 1, 2 * N))
      table.insert(t[2], tableofstring(s, 2 * N + 1, 3 * N))
   end
   for _ = 1, N do
      local s = io.read()
      table.insert(t[3], tableofstring(s, N + 1, 2 * N))
   end
   for _ = 1, N do
      local s = io.read()
      table.insert(t[4], tableofstring(s, 1, N))
      table.insert(t[5], tableofstring(s, N + 1, 2 * N))
   end
   for _ = 1, N do
      local s = io.read()
      table.insert(t[6], tableofstring(s, 1, N))
   end
   for i, t in pairs(t) do
      for _, t in pairs(t) do
         assert(#t == N)
      end
   end
   io.read() -- skip empty line
   return t, nextdir(io.read())
end

-- implement cube face wrapping
function nextpos(t, i, x, y, o)
   if not (1 <= i and i <= 6 and 0 <= o and o <= 3) then
      print(i, o)
      assert(nil)
   end
   if o == 0 then -- right
      if x < N then
         x = x + 1
      else -- x == N
         assert(x == N)
         if i == 1 then
            i, x = 2, 1
         elseif i == 2 then
            i, x, y, o = 5, N, N - y + 1, 2
         elseif i == 3 then
            i, x, y, o = 2, y, N, 3
         elseif i == 4 then
            i, x = 5, 1
         elseif i == 5 then
            i, x, y, o = 2, N, N - y + 1, 2
         elseif i == 6 then
            i, x, y, o = 5, y, N, 3
         end
      end
   elseif o == 1 then -- down
      if y < N then
         y = y + 1
      else -- y == N
         assert(y == N)
         if i == 1 then
            i, y = 3, 1
         elseif i == 2 then
            i, x, y, o = 3, N, x, 2
         elseif i == 3 then
            i, y = 5, 1
         elseif i == 4 then
            i, y = 6, 1
         elseif i == 5 then
            i, x, y, o = 6, N, x, 2
         elseif i == 6 then
            i, y = 2, 1
         end
      end
   elseif o == 2 then -- left
      if x > 1 then
         x = x - 1
      else -- x == 1
         assert(x == 1)
         if i == 1 then
            i, x, y, o = 4, 1, N - y + 1, 0
         elseif i == 2 then
            i, x = 1, N
         elseif i == 3 then
            i, x, y, o = 4, y, 1, 1
         elseif i == 4 then
            i, x, y, o = 1, 1, N - y + 1, 0
         elseif i == 5 then
            i, x = 4, N
         elseif i == 6 then
            i, x, y, o = 1, y, 1, 1
         end
      end
   elseif o == 3 then -- up
      if y > 1 then
         y = y - 1
      else -- y == 1
         assert(y == 1)
         if i == 1 then
            i, x, y, o = 6, 1, x, 0
         elseif i == 2 then
            i, y = 6, N
         elseif i == 3 then
            i, y = 1, N
         elseif i == 4 then
            i, x, y, o = 3, 1, x, 0
         elseif i == 5 then
            i, y = 3, N
         elseif i == 6 then
            i, y = 4, N
         end
      end
   end
   return i, x, y, o
end

function domove(t, i, x, y, o)
   local i1, x1, y1, o1 = nextpos(t, i, x, y, o)
   local c = t[i1][y1][x1]
   if c == '#' then
      return i, x, y, o
   elseif c == '.' then
      return i1, x1, y1, o1
   else
      assert(nil)
   end
end

-- d = step to perform (L, R, number)
-- i = current face number
-- x, y = current face coordinates
-- o = current facing
function dostep(t, d, i, x, y, o)
   if d == 'L' then
      o = (o - 1) % 4
   elseif d == 'R' then
      o = (o + 1) % 4
   else -- type(d) == "number"
      for _ = 1, d do
         i, x, y, o = domove(t, i, x, y, o)
      end
   end
   return i, x, y, o
end

function tomap(i, x, y)
   assert(1 <= i and i <= 6)
   if i == 1 then
      x = x + N
   elseif i == 2 then
      x = x + 2 * N
   elseif i == 3 then
      x, y = x + N, y + N
   elseif i == 4 then
      y = y + 2 * N
   elseif i == 5 then
      x, y = x + N, y + 2 * N
   elseif i == 6 then
      y = y + 3 * N
   end
   return x, y
end

function main()
   local t, nextdir = read()
   local i, x, y, o = 1, 1, 1, 0 -- facing right
   for d in nextdir do
      i, x, y, o = dostep(t, d, i, x, y, o)
   end
   x, y = tomap(i, x, y)
   return 1000 * y + 4 * x + o
end

print(main())

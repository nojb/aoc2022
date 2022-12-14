function set(t, x, y)
   if not t[x] then t[x] = {} end
   t[x][y] = true
end

function isset(t, x, y)
   return t[x] and t[x][y]
end

function swap(x, y)
   return y, x
end

function setpath(t, x1, y1, x2, y2)
   if x1 == x2 then
      -- swap y1 and y2 so that y1 <= y2
      if y2 < y1 then y1, y2 = swap(y1, y2) end
      for y = y1, y2 do set(t, x1, y) end
   else -- y1 == y2
      -- swap x1 and x2 so that x1 <= x2
      if x2 < x1 then x1, x2 = swap(x1, x2) end
      for x = x1, x2 do set(t, x, y1) end
   end
end

function nextpath(s)
   local m = string.gmatch(s, "(%d+),(%d+)")
   local x1, y1 = m()
   x1, y1 = tonumber(x1), tonumber(y1)
   return function ()
      local a1, b1 = x1, y1
      x1, y1 = m()
      if x1 and y1 then
         x1, y1 = tonumber(x1), tonumber(y1)
         return a1, b1, x1, y1
      end
   end
end

function read()
   local t = {}
   local maxy = 0
   for s in io.lines() do
      for x1, y1, x2, y2 in nextpath(s) do
         setpath(t, x1, y1, x2, y2)
         if y1 > maxy then maxy = y1 end
         if y2 > maxy then maxy = y2 end
      end
   end
   return t, maxy
end

-- simulate a falling grain of sand starting at 500, 0.  Return true if the
-- grain of sand comes to rest, false otherwise.
function doround(t, maxy)
   local x, y = 500, 0
   while true do
      if y > maxy then
         return false
      elseif not isset(t, x, y + 1) then
         y = y + 1
      elseif not isset(t, x - 1, y + 1) then
         x, y = x - 1, y + 1
      elseif not isset(t, x + 1, y + 1) then
         x, y = x + 1, y + 1
      else
         set(t, x, y)
         return true
      end
   end
end

function main()
   local t, maxy = read()
   local i = 0
   while doround(t, maxy) do
      i = i + 1
   end
   return i
end

print(main())

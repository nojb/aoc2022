function compare2(t1, t2, i)
   if i > #t1 and i <= #t2 then
      return -1
   elseif i > #t2 and i <= #t1 then
      return 1
   elseif i > #t1 and i > #t2 then
      return 0
   else -- i <= #t1 and i <= #t2
      local x1 = t1[i]
      local x2 = t2[i]
      if type(x1) == "number" and type(x2) == "number" then
         if x1 < x2 then
            return -1
         elseif x2 < x1 then
            return 1
         else
            return compare2(t1, t2, i + 1)
         end
      else -- type(x1) == "table" or type(x2) == "table"
         if type(x1) == "number" then x1 = {x1} end
         if type(x2) == "number" then x2 = {x2} end
         local c = compare2(x1, x2, 1)
         if c == 0 then
            return compare2(t1, t2, i + 1)
         else
            return c
         end
      end
   end
end

function compare(t1, t2)
   return compare2(t1, t2, 1)
end

function parsenumberorlist(s, i)
   return parsenumber(s, i) or parselist(s, i)
end

function parsenumber(s, i)
   local s, i = string.match(s, "^(%d+)()", i)
   if not s then
      return
   else
      return { d = tonumber(s), i = i }
   end
end

function parselist(s, i)
   local c = string.sub(s, i, i)
   if c ~= '[' then return nil end
   i = i + 1
   if string.sub(s, i, i) == ']' then
      return { d = {}, i = i + 1 }
   end
   local t = {}
   while true do
      local x = parsenumberorlist(s, i)
      table.insert(t, x.d)
      i = x.i
      local c = string.sub(s, i, i)
      if c == ',' then
         i = i + 1
      elseif c == ']' then
         i = i + 1
         break
      else
         assert(nil)
      end
   end
   return { d = t, i = i }
end

function parsepacket(s)
   local x = parselist(s, 1)
   assert(x.i == string.len(s) + 1)
   return x.d
end

function main()
   local i = 1
   local tot = 0
   repeat
      local s1 = assert(io.read())
      if not s1 then break end
      local s2 = assert(io.read())
      if compare(parsepacket(s1), parsepacket(s2)) <= 0 then
         tot = tot + i
      end
      i = i + 1
   until not (io.read())
   return tot
end

print(main())

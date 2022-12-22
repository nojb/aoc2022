key = 811589153

function read()
   local t = {}
   local i = 0
   local prev
   local zero
   for s in io.lines() do
      i = i + 1
      local x = {prev = prev, num = tonumber(s) * key}
      if i > 1 then prev.next = x end
      prev = x
      t[i] = x
      if x.num == 0 then zero = i end
   end
   t[#t].next = t[1]
   t[1].prev = t[#t]
   return t, zero
end

function mix(t, pos)
   local x = t[pos]
   local d = x.num % (#t - 1)
   if d == 0 then return end
   x.next.prev = x.prev
   x.prev.next = x.next
   local next = x
   for _ = 1, d do
      next = next.next
   end
   next.next.prev = x
   x.next = next.next
   x.prev = next
   next.next = x
end

function display(t)
   local first = t[1]
   repeat
      io.write(string.format("%d, ", first.num))
      first = first.next
   until first == t[1]
   io.write('\n')
end

function main()
   local t, zero = read()
   -- print(zero)
   -- display(t)
   for _ = 1, 10 do
      for pos = 1, #t do
         mix(t, pos)
         -- display(t)
      end
   end
   local function get(i)
      local x = t[zero]
      i = i % #t
      for _ = 1, i do
         x = x.next
      end
      return x.num
   end
   return get(1000) + get(2000) + get(3000)
end

print(main())

function priority(c)
   local a, z, A, Z = string.byte("a"), string.byte("z"), string.byte("A"), string.byte("Z")
   if a <= c and c <= z then
      return c - a + 1
   elseif A <= c and c <= Z then
      return c - A + 27
   else
      error("unexpected character", c)
   end
end

function scan(l)
   local seen = {}
   for i = 1, string.len(l) do
      seen[string.byte(l, i)] = true
   end
   return seen
end

total = 0

while true do
   local l1, l2, l3 = io.read(), io.read(), io.read()
   if not l1 or not l2 or not l3 then -- end of file
      break
   end
   seen1 = scan(l1)
   seen2 = scan(l2)
   seen3 = scan(l3)
   for i = 1, string.len(l1) do -- could also use l2 or l3
      local b = string.byte(l1, i)
      if seen1[b] and seen2[b] and seen3[b] then
         total = total + priority(b)
         break
      end
   end
end

print(total)

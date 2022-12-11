function priority(c)
   local a, z, A, Z = string.byte("a"), string.byte("z"), string.byte("A"), string.byte("Z")
   if a <= c and c <= z then
      return c - a + 1
   elseif A <= c and c <= Z then
      return c - A + 27
   else
      error("unexpected character")
   end
end

function findcommon(l, r)
   local seen = {}
   for i = 1, string.len(l) do
      seen[string.byte(l, i)] = true
   end
   for i = 1, string.len(r) do
      local b = string.byte(r, i)
      if seen[b] then
         return priority(b)
      end
   end
   error("findcommon")
end

total = 0

while true do
   local line = io.read()
   if line == nil then -- end of file
      break
   end
   local len2 = string.len(line) / 2
   local l, r = string.sub(line, 1, len2), string.sub(line, - len2)
   total = total + findcommon(l, r)
end

print(total)

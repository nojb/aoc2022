total = 0

-- whether [l1, r1] is contained in [l2, r2]
function contained(l1, r1, l2, r2)
   return (l2 <= l1 and r1 <= r2)
end

while true do
   local s = io.read()
   if not s then break end -- end of file
   local l1, r1, l2, r2 = string.match(s, "(%d+)-(%d+),(%d+)-(%d+)")
   l1 = tonumber(l1)
   r1 = tonumber(r1)
   l2 = tonumber(l2)
   r2 = tonumber(r2)
   if contained(l1, r1, l2, r2) or contained(l2, r2, l1, r1) then
      total = total + 1
   end
end

print(total)
